// ProviderConsole.aspx.cs
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;

namespace ExpandifySA
{
    // NOTE: Make sure your .aspx has: Inherits="ExpandifySA.ProviderConsole"
    public partial class ProviderConsole : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No full postbacks; everything is JS + PageMethods
            // You can add auth checks here if needed (e.g., redirect if not logged in)
        }

        // -------------------------
        // Data models (DTOs)
        // -------------------------
        public class ProviderPrefs
        {
            public double Lng { get; set; }
            public double Lat { get; set; }
            public int RadiusMeters { get; set; }
            public DateTime UpdatedAt { get; set; }
        }

        public class ProfileDto
        {
            public string Name { get; set; }
            public string Email { get; set; }
            public string Phone { get; set; }
            public string Services { get; set; }
            public string About { get; set; }
        }

        public class BankDto
        {
            public string Bank { get; set; }
            public string AccountNumber { get; set; }
            public DateTime LinkedAt { get; set; }
        }

        public class CashoutDto
        {
            public Guid Reference { get; set; }
            public decimal Amount { get; set; }
            public DateTime RequestedAt { get; set; }
            public string Status { get; set; } // e.g., "submitted"
        }

        // -------------------------
        // Helpers
        // -------------------------
        private static HttpSessionStateBase S
        {
            get
            {
                var ctx = new HttpContextWrapper(HttpContext.Current);
                return new HttpSessionStateWrapper(ctx.Session);
            }
        }

        private static List<CashoutDto> GetCashouts()
        {
            var list = S["cashouts"] as List<CashoutDto>;
            if (list == null)
            {
                list = new List<CashoutDto>();
                S["cashouts"] = list;
            }
            return list;
        }

        // -------------------------
        // PageMethods (AJAX JSON)
        // -------------------------

        /// <summary>
        /// Save map prefs (center + radius) for the provider.
        /// </summary>
        [WebMethod(EnableSession = true)]
        public static object SaveProviderPrefs(double lng, double lat, int radius_m)
        {
            var prefs = new ProviderPrefs
            {
                Lng = lng,
                Lat = lat,
                RadiusMeters = radius_m,
                UpdatedAt = DateTime.UtcNow
            };
            S["provider_prefs"] = prefs;

            return new
            {
                ok = true,
                saved = prefs
            };
        }

        /// <summary>
        /// Request a wallet cashout. (Mock—it just stores a session record.)
        /// </summary>
        [WebMethod(EnableSession = true)]
        public static object CashOut(decimal amount)
        {
            if (amount <= 0)
            {
                return new { ok = false, error = "Amount must be greater than zero." };
            }

            var rec = new CashoutDto
            {
                Reference = Guid.NewGuid(),
                Amount = amount,
                RequestedAt = DateTime.UtcNow,
                Status = "submitted"
            };

            var cashouts = GetCashouts();
            cashouts.Add(rec);

            return new
            {
                ok = true,
                reference = rec.Reference.ToString(),
                status = rec.Status,
                when = rec.RequestedAt
            };
        }

        /// <summary>
        /// Save profile fields to session (mock DB).
        /// </summary>
        [WebMethod(EnableSession = true)]
        public static object SaveProfile(ProfileDto profile)
        {
            if (profile == null)
            {
                return new { ok = false, error = "Invalid profile payload." };
            }

            S["profile"] = profile;
            return new { ok = true };
        }

        /// <summary>
        /// Load profile fields from session.
        /// </summary>
        [WebMethod(EnableSession = true)]
        public static object LoadProfile()
        {
            var profile = S["profile"] as ProfileDto;
            if (profile == null)
            {
                // Empty default
                profile = new ProfileDto
                {
                    Name = "",
                    Email = "",
                    Phone = "",
                    Services = "",
                    About = ""
                };
            }

            var bank = S["bank"] as BankDto;

            return new
            {
                ok = true,
                profile,
                bank
            };
        }

        /// <summary>
        /// Save bank info (link/replace).
        /// </summary>
        [WebMethod(EnableSession = true)]
        public static object SaveBank(string bank, string accountNumber)
        {
            if (string.IsNullOrWhiteSpace(bank) || string.IsNullOrWhiteSpace(accountNumber))
            {
                return new { ok = false, error = "Bank and account number are required." };
            }

            var dto = new BankDto
            {
                Bank = bank.Trim(),
                AccountNumber = accountNumber.Trim(),
                LinkedAt = DateTime.UtcNow
            };
            S["bank"] = dto;

            return new { ok = true, bank = dto };
        }

        // -------------------------
        // (Optional) Small utilities to inspect server state while testing
        // -------------------------

        /// <summary>
        /// For debugging: read back what the server "knows" about you in session.
        /// </summary>
        [WebMethod(EnableSession = true)]
        public static object DebugSession()
        {
            return new
            {
                ok = true,
                prefs = S["provider_prefs"] as ProviderPrefs,
                profile = S["profile"] as ProfileDto,
                bank = S["bank"] as BankDto,
                cashouts = GetCashouts()
            };
        }
    }
}
