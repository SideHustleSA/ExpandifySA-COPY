using System;

namespace ExpandifySA
{
    public partial class CustomerDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Example of sourcing values from Session (or database)
                lblUsername.Text = (Session["UserName"] as string) ?? "Starboy";
                lblFullName.Text = (Session["FullName"] as string) ?? "Wandile Ngubo";
                lblCash.Text     = (Session["Cash"]     as string) ?? "0.00";
            }
        }

        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            // Do your sign-out logic here
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}
