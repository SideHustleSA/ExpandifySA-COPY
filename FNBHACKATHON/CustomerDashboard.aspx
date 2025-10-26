<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerDashboard.aspx.cs" Inherits="ExpandifySA.CustomerDashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>ExpandifySA — Customer Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
  <style>
    :root{
      --indigo:#667eea; --purple:#764ba2;
      --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --text:#0b0b0b; --muted:#6b7280; --border:#e2e8f0;
      --card:#ffffff; --soft:#f7fafc;
    }
    *{box-sizing:border-box;}
    body{margin:0; font-family:'Poppins',sans-serif; color:var(--text); background:#fff;}

    /* HEADER */
    .nav{background:var(--gradient); color:#fff; position:sticky; top:0; z-index:50; box-shadow:0 3px 10px rgba(0,0,0,.2)}
    .nav-inner{max-width:1200px; margin:auto; padding:14px 20px; display:flex; align-items:center; justify-content:space-between; gap:16px}
    .brand{display:flex; align-items:center; gap:10px; font-weight:700}
    .logo{width:30px; height:30px; border-radius:6px; background:#fff; color:var(--purple); display:grid; place-items:center; font-weight:700}
    .nav-links{display:flex; gap:18px}
    .nav-links a{color:#fff; text-decoration:none; font-weight:500; opacity:.95}

    /* User pill + dropdown */
    .nav-user{position:relative; display:flex; align-items:center; gap:10px; background:rgba(255,255,255,.15); padding:8px 12px; border-radius:999px; cursor:pointer}
    .avatar{width:28px; height:28px; border-radius:50%; background:#fff; color:var(--purple); display:grid; place-items:center; font-weight:700; font-size:12px}
    .username{font-weight:600}

    .profile-dropdown{
      display:none; position:absolute; right:0; top:48px; width:280px; background:#fff; color:#000;
      border-radius:12px; box-shadow:0 12px 28px rgba(0,0,0,.15); padding:16px; z-index:999;
    }
    .profile-header{display:flex; align-items:center; justify-content:space-between; margin-bottom:14px}
    .profile-header h3{margin:0; font-size:20px; font-weight:800}
    .profile-avatar{width:44px; height:44px; border-radius:50%; background:var(--soft); display:grid; place-items:center; font-size:22px; color:var(--muted)}

    .profile-buttons{display:grid; grid-template-columns:repeat(3,1fr); gap:10px; margin-bottom:14px}
    .profile-btn{background:var(--soft); border:none; border-radius:12px; padding:12px; text-align:center; cursor:pointer}
    .profile-btn:hover{background:#eef2ff}
    .profile-btn span{display:block; font-size:13px; color:var(--muted); margin-top:6px}

    .profile-balance{background:#f8fafc; border-radius:12px; padding:10px 14px; display:flex; justify-content:space-between; font-weight:700; margin-bottom:10px}
    .profile-item{display:flex; align-items:center; gap:10px; padding:10px 0; border-bottom:1px solid #f1f5f9; cursor:pointer}
    .profile-item:last-child{border-bottom:none}
    .profile-item:hover{background:#fafaff}
    .signout-btn{width:100%; background:#fff5f5; color:#e53e3e; border:none; border-radius:12px; padding:12px; font-weight:700; margin-top:12px; cursor:pointer}
    .signout-btn:hover{background:#ffe4e4}

    /* HERO */
    .hero{max-width:1200px; margin:40px auto; padding:0 20px; display:grid; grid-template-columns:1.15fr .85fr; gap:28px}
    @media (max-width:960px){.hero{grid-template-columns:1fr}}
    h1{font-size:48px; line-height:1.05; margin:0 0 14px}
    .muted{color:var(--muted)}
    .form{background:var(--card); border:1px solid var(--border); border-radius:16px; padding:14px; box-shadow:0 10px 30px rgba(0,0,0,.1); max-width:540px}
    .input{display:flex; align-items:center; gap:10px; padding:12px 14px; background:var(--soft); border:2px solid var(--border); border-radius:12px; margin-bottom:10px}
    .input:focus-within{border-color:#667eea; box-shadow:0 0 0 3px rgba(102,126,234,.15)}
    .input input,.input select{border:none; outline:none; background:transparent; width:100%; font-size:15px}
    .cta{width:100%; padding:14px 16px; border:none; border-radius:12px; font-weight:600; cursor:pointer; color:#fff; background:var(--gradient); box-shadow:0 12px 28px rgba(118,75,162,.35)}
    .hero-visual{border-radius:22px; overflow:hidden; min-height:360px; background:#f0f2ff; display:grid; place-items:center; border:1px solid var(--border)}
    .hero-visual img{width:100%; height:100%; object-fit:cover}

    /* SUGGESTIONS */
    .section{max-width:1200px; margin:40px auto; padding:0 20px}
    .section h2{font-size:34px; margin:0 0 16px}
    .grid{display:grid; gap:18px; grid-template-columns:repeat(3,1fr)}
    @media (max-width:1024px){.grid{grid-template-columns:repeat(2,1fr)}}
    @media (max-width:640px){.grid{grid-template-columns:1fr}}
    .card{background:#fff; border:1px solid var(--border); border-radius:16px; padding:18px; display:flex; align-items:center; justify-content:space-between; gap:16px; transition:.1s}
    .card:hover{transform:translateY(-2px); box-shadow:0 12px 28px rgba(0,0,0,.08)}
    .card h3{margin:0 0 6px; font-size:18px}
    .card p{margin:0; color:var(--muted); font-size:14px}
    .chip{display:inline-block; margin-top:10px; padding:8px 12px; border-radius:999px; font-size:13px; background:var(--gradient); color:#fff; text-decoration:none}
    .icon{width:64px; height:64px; border-radius:12px; display:grid; place-items:center; font-size:24px; background:var(--gradient); color:#fff}

    /* RESERVE */
    .reserve{display:grid; grid-template-columns:1.1fr .9fr; gap:22px; border-radius:18px; padding:22px; background:linear-gradient(135deg, rgba(102,126,234,.12), rgba(118,75,162,.12)); border:1px solid var(--border)}
    @media (max-width:960px){.reserve{grid-template-columns:1fr}}
    .reserve h3{margin:0 0 8px; font-size:30px}
    .reserve .input{background:#fff}
    .reserve .next{padding:12px 16px; border:none; border-radius:12px; font-weight:600; cursor:pointer; color:#fff; background:var(--gradient)}
    .benefits{background:#fff; border:1px solid var(--border); border-radius:16px; padding:16px}
    .benefits h4{margin:0 0 8px}
    .benefits ul{margin:0; padding:0; list-style:none}
    .benefits li{padding:12px 0; border-bottom:1px solid var(--border); color:var(--muted); font-size:14px}
    .benefits li:last-child{border-bottom:none}

    /* STICKY BUTTON */
    .sticky{position:sticky; bottom:0; background:#000; padding:14px 20px; display:flex; justify-content:center}
    .sticky button{border:none; border-radius:12px; font-weight:600; padding:14px 18px; color:#fff; cursor:pointer; width:100%; max-width:1180px; background:var(--gradient)}

    /* FOOTER */
    footer{margin-top:30px; background:var(--gradient); color:#fff; padding:40px 20px}
    .fwrap{max-width:1200px; margin:auto; display:flex; justify-content:space-between; gap:16px; flex-wrap:wrap}
    footer a{color:#fff; text-decoration:none; font-weight:500}
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <!-- HEADER -->
    <header class="nav">
      <div class="nav-inner">
        <div class="brand">
          <div class="logo">Ex</div>
          <div>ExpandifySA</div>
        </div>

        <nav class="nav-links">
          <a href="#request">Request</a>
          <a href="#reserve">Reserve</a>
          <a href="#prices">See prices</a>
          <a href="#suggestions">Explore options</a>
        </nav>

        <!-- USER + DROPDOWN -->
        <div class="nav-user" id="userProfile">
          <div class="avatar">SB</div>
          <span class="username"><asp:Label ID="lblUsername" runat="server" Text="Starboy"></asp:Label></span>

          <div class="profile-dropdown" id="profileDropdown">
            <div class="profile-header">
              <h3><asp:Label ID="lblFullName" runat="server" Text="Wandile Ngubo"></asp:Label></h3>
              <div class="profile-avatar">👤</div>
            </div>

            <div class="profile-buttons">
              <button type="button" class="profile-btn" onclick="alert('Help')">⚙️<span>Help</span></button>
              <button type="button" class="profile-btn" onclick="alert('Wallet')">💳<span>Wallet</span></button>
              <button type="button" class="profile-btn" onclick="alert('Activity')">📋<span>Activity</span></button>
            </div>

            <div class="profile-balance">
              <span>Expandify Cash</span>
              <span>ZAR <asp:Label ID="lblCash" runat="server" Text="0.00"></asp:Label></span>
            </div>

            <div class="profile-item" onclick="alert('Manage account')">👤 <span>Manage account</span></div>
            <div class="profile-item" onclick="alert('Promotions')">🏷️ <span>Promotions</span></div>

            <asp:Button ID="btnSignOut" runat="server" CssClass="signout-btn" Text="Sign out" OnClick="btnSignOut_Click" />
          </div>
        </div>
      </div>
    </header>

    <!-- HERO -->
    <section id="request" class="hero">
      <div>
        <h1>Request a service<br/>for now or later</h1>
        <p class="muted">Add your details, pick a pro, and go.</p>

        <div class="form">
          <div class="input"><span>📍</span><input placeholder="Enter your location" required /></div>
          <div class="input">
            <span>🧰</span>
            <select required>
              <option value="" hidden>Select a service</option>
              <option>Plumbing</option><option>Electrical</option><option>Cleaning</option>
              <option>Painting</option><option>Handyman</option>
            </select>
          </div>
          <div class="input"><span>📝</span><input placeholder="Add brief job notes (optional)" /></div>
          <button class="cta" type="button" onclick="alert('Searching pros…')">See pros</button>
        </div>
      </div>

      <div class="hero-visual" aria-hidden="true">
        <img src="https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?q=80&w=1600&auto=format&fit=crop" alt="Friendly service providers"/>
      </div>
    </section>

    <!-- SUGGESTIONS -->
    <section id="suggestions" class="section">
      <h2>Suggestions</h2>
      <div class="grid">
        <article class="card">
          <div>
            <h3>Plumbing</h3>
            <p>Fix leaks, geysers, blocked drains.</p>
            <a class="chip" href="#">Details</a>
          </div>
          <div class="icon">🚿</div>
        </article>

        <article class="card">
          <div>
            <h3>Reserve</h3>
            <p>Book a time in advance and relax.</p>
            <a class="chip" href="#reserve">Details</a>
          </div>
          <div class="icon">🗓️</div>
        </article>

        <article class="card">
          <div>
            <h3>Learn a Skill</h3>
            <p>Short lessons in plumbing, electrical, painting & more.</p>
            <a class="chip" href="#">Explore</a>
          </div>
          <div class="icon">🎓</div>
        </article>
      </div>
    </section>

    <!-- RESERVE -->
    <section id="reserve" class="section">
      <div class="reserve">
        <div>
          <h3>Get your service right with Expandify Reserve</h3>
          <p class="muted">Choose date and time</p>
          <form class="reserve-form" onsubmit="event.preventDefault(); alert('Next step…');">
            <div class="input"><span>📅</span><input type="date" required /></div>
            <div class="input"><span>⏰</span><input type="time" required /></div>
            <div class="input">
              <span>🧰</span>
              <select required>
                <option value="" hidden>Select a service</option>
                <option>Plumbing</option><option>Electrical</option><option>Cleaning</option>
                <option>Painting</option><option>Handyman</option>
              </select>
            </div>
            <button class="next" type="submit">Next</button>
          </form>
        </div>
        <aside class="benefits">
          <h4>Benefits</h4>
          <ul>
            <li>Choose your exact time up to 90 days in advance.</li>
            <li>Extra wait time included to meet your provider.</li>
            <li>Cancel at no charge up to 60 minutes in advance.</li>
          </ul>
          <a href="#" style="font-weight:600; color:#111;">See terms</a>
        </aside>
      </div>
    </section>

    <!-- STICKY BUTTON -->
    <div id="prices" class="sticky">
      <button type="button" onclick="alert('Showing prices…')">See prices</button>
    </div>

    <!-- FOOTER -->
    <footer>
      <div class="fwrap">
        <div>© <span id="y"></span> ExpandifySA</div>
        <div><a href="#">Help</a> • <a href="#">Safety</a> • <a href="#">Terms</a> • <a href="#">Privacy</a></div>
      </div>
    </footer>
  </form>

  <script>
    document.getElementById('y').textContent = new Date().getFullYear();

    // Profile dropdown toggle + click-outside close
    const userProfile = document.getElementById('userProfile');
    const dropdown = document.getElementById('profileDropdown');

    userProfile.addEventListener('click', (e) => {
      e.stopPropagation();
      dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    });

    document.addEventListener('click', (e) => {
      if (!userProfile.contains(e.target)) dropdown.style.display = 'none';
    });
  </script>
</body>
</html>
