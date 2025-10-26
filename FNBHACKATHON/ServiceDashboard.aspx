<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
<meta charset="utf-8" />
<title>ExpandifySA – Provider Console</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
<link href="https://unpkg.com/maplibre-gl@3.6.1/dist/maplibre-gl.css" rel="stylesheet"/>
<link href="https://unpkg.com/maplibre-gl-gesture-handling/dist/gesture-handling.css" rel="stylesheet"/>
<style>
  :root{
    --bg:#0f1222; --panel:#151834; --panel-2:#1b1f3f; --accent:#6f7cff; --accent-2:#9a78ff;
    --text:#e7e9ff; --muted:#9aa0c3; --good:#13d67a; --warn:#ffcc00; --danger:#ff6b6b;
    --border:#2a2f5a; --success:#19d67a;
  }
  *{box-sizing:border-box}
  body{ margin:0; font-family:Poppins,system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,"Helvetica Neue",sans-serif;
    background:linear-gradient(135deg,#0b1022,#191e42 45%,#1b1642); color:var(--text); height:100vh; overflow:hidden; }
  .app{display:grid; grid-template-columns:260px 1fr; grid-template-rows:64px 1fr; grid-template-areas:"sidebar header" "sidebar main"; height:100vh;}

  /* Sidebar */
  .sidebar{grid-area:sidebar; background:linear-gradient(180deg,#171a39,#121531); border-right:1px solid var(--border); padding:14px 12px; display:flex; flex-direction:column; gap:10px;}
  .brand{display:flex; align-items:center; gap:10px; padding:10px 8px; margin-bottom:6px;}
  .logo{width:36px; height:36px; border-radius:10px; background:linear-gradient(135deg,var(--accent),var(--accent-2)); display:grid; place-items:center; font-weight:800; color:#0b0e1b;}
  .brand .name{font-weight:700; letter-spacing:.3px}
  .nav{display:flex; flex-direction:column; gap:6px; margin-top:8px}
  .nav a{display:flex; align-items:center; gap:10px; padding:11px 12px; border-radius:10px; color:var(--text); text-decoration:none; border:1px solid transparent; transition:.2s;}
  .nav a .ix{width:22px; text-align:center; opacity:.9}
  .nav a:hover{background:var(--panel-2); border-color:var(--border)}
  .nav a.active{background:linear-gradient(135deg,rgba(111,124,255,.18),rgba(154,120,255,.12)); border-color:var(--accent)}
  .spacer{flex:1}
  .support{margin-top:auto; border-top:1px dashed var(--border); padding-top:10px}
  .tiny{font-size:.8rem; color:var(--muted)}

  /* Header */
  .header{grid-area:header; display:flex; align-items:center; justify-content:space-between; padding:10px 16px; border-bottom:1px solid var(--border); background:rgba(15,18,34,.55); backdrop-filter: blur(6px);}
  .status{display:flex; align-items:center; gap:12px; background:var(--panel); border:1px solid var(--border); padding:8px 12px; border-radius:10px;}
  .pill{position:relative; width:64px; height:30px; background:#0f1330; border:1px solid var(--border); border-radius:999px; cursor:pointer;}
  .dot{position:absolute; top:3px; left:3px; width:24px; height:24px; border-radius:50%; background:linear-gradient(135deg,#2b2f58,#4a4fa0); transition:.22s;}
  .pill.online{background:linear-gradient(135deg,rgba(19,214,122,.15),rgba(111,124,255,.15));}
  .pill.online .dot{left:37px; background:linear-gradient(135deg,#19d67a,#76f2b2)}
  .hdr-right{display:flex; align-items:center; gap:12px}
  .chip{padding:8px 12px; border-radius:10px; background:var(--panel); border:1px solid var(--border); color:var(--muted); font-weight:600;}
  .primary{background:linear-gradient(135deg,var(--accent),var(--accent-2)); color:#0b0f1d; border:none; font-weight:800; padding:10px 14px; border-radius:10px; cursor:pointer;}
  .btn-ghost{background:var(--panel); border:1px solid var(--border); color:var(--text); border-radius:10px; padding:8px 10px; cursor:pointer;}

  /* Main container that swaps views */
  .main{grid-area:main; height:calc(100vh - 64px); overflow:auto; padding:12px;}
  .view{display:none;}
  .view.show{display:grid;}

  /* MAP VIEW LAYOUT */
  .map-layout{grid-template-columns:1fr 360px; gap:12px;}
  .map{position:relative; border:1px solid var(--border); border-radius:14px; overflow:hidden; background:#0a0d24;}
  #ml-map{position:absolute; inset:0;}
  .controls{position:absolute; right:12px; top:12px; display:flex; flex-direction:column; gap:8px; z-index:5;}
  .ctrl{width:40px; height:40px; border-radius:10px; display:grid; place-items:center; background:var(--panel); border:1px solid var(--border); cursor:pointer;}
  .go{position:absolute; left:50%; bottom:18px; transform:translateX(-50%); padding:14px 22px; border-radius:999px; background:linear-gradient(135deg,var(--good),#6fffc7); color:#0a1323; font-weight:900; border:none; cursor:pointer; box-shadow:0 10px 30px rgba(19,214,122,.25); z-index:5;}
  .go.off{background:linear-gradient(135deg,#3a406f,#5a62b5); color:#e6e9ff; box-shadow:none}

  .radius-ui{position:absolute; left:12px; top:12px; z-index:6; background:rgba(21,24,52,.92); border:1px solid var(--border); border-radius:12px; padding:10px; min-width:280px; box-shadow:0 10px 30px rgba(0,0,0,.25);}
  .radius-ui .row{display:flex; gap:8px; align-items:center; margin-bottom:8px}
  .radius-ui input[type="search"], .radius-ui input[type="number"]{background:#0f1430; border:1px solid var(--border); color:var(--text); padding:8px 10px; border-radius:10px; font-family:inherit; flex:1;}
  .radius-ui input[type="range"]{ width:100% }
  .radius-ui .btn{ padding:8px 10px; border-radius:10px; border:1px solid var(--border); background:var(--panel-2); color:var(--text); cursor:pointer }
  .radius-ui small{ color:var(--muted) }

  .panel{background:var(--panel); border:1px solid var(--border); border-radius:14px; padding:12px; display:flex; flex-direction:column; gap:12px;}
  .panel h3{margin:0; font-size:1rem}
  .row{display:flex; align-items:center; justify-content:space-between; gap:8px}
  .earn-num{font-size:1.8rem; font-weight:800}
  .progress{height:10px; background:#0e1230; border-radius:999px; overflow:hidden; border:1px solid var(--border)}
  .bar{height:100%; width:38%; background:linear-gradient(90deg,var(--accent),var(--accent-2))}
  .list{display:flex; flex-direction:column; gap:8px}
  .item{display:flex; justify-content:space-between; gap:8px; padding:10px; border:1px dashed var(--border); border-radius:10px; background:rgba(20,25,55,.45)}
  .muted{color:var(--muted)}

  .request{position:absolute; left:18px; bottom:18px; width:360px; background:var(--panel);
    border:1px solid var(--border); border-radius:16px; padding:14px; display:none; box-shadow:0 20px 50px rgba(0,0,0,.35); z-index:6;}
  .request.show{display:block}
  .badge{display:inline-flex; gap:6px; align-items:center; padding:6px 10px; border-radius:999px; background:rgba(255,255,255,.06); border:1px solid var(--border); font-size:.85rem;}
  .req-row{display:flex; align-items:center; justify-content:space-between; margin:8px 0}
  .req-title{font-weight:700; font-size:1.05rem}
  .req-meta{display:flex; gap:10px; color:var(--muted); font-size:.9rem}
  .req-actions{display:flex; gap:10px; margin-top:10px}
  .btn{flex:1; padding:10px 12px; border-radius:10px; font-weight:700; cursor:pointer; border:1px solid var(--border); background:var(--panel-2); color:var(--text);}
  .btn.primary{background:linear-gradient(135deg,var(--good),#6fffc7); color:#071021; border:none}
  .btn.danger{background:linear-gradient(135deg,#2b2f58,#4b4fa0);}

  .drawer{position:fixed; right:12px; top:76px; width:480px; max-height:calc(100vh - 92px); overflow:auto; background:var(--panel); border:1px solid var(--border); border-radius:14px; padding:12px; display:none;}
  .drawer.show{display:block}
  .job{border:1px solid var(--border); border-radius:12px; padding:10px; margin-bottom:10px; background:rgba(18,22,50,.55)}

  /* EARNINGS VIEW */
  .earnings-layout{grid-template-columns:1fr; gap:12px;}
  .tabs{display:flex; gap:8px; flex-wrap:wrap}
  .tab{padding:8px 12px; border-radius:999px; border:1px solid var(--border); background:var(--panel); cursor:pointer; font-weight:600; color:var(--muted)}
  .tab.active{background:linear-gradient(135deg,rgba(111,124,255,.18),rgba(154,120,255,.12)); color:var(--text); border-color:var(--accent)}
  .kpis{display:grid; grid-template-columns: repeat(6, minmax(120px,1fr)); gap:12px}
  .card{background:var(--panel); border:1px solid var(--border); border-radius:12px; padding:12px}
  .card h4{margin:0; font-size:.9rem; color:var(--muted)}
  .card .big{font-size:1.4rem; font-weight:800; margin-top:6px}
  .filters{display:flex; gap:10px; align-items:center; flex-wrap:wrap}
  .filters input{background:#0f1430; border:1px solid var(--border); color:var(--text); padding:8px 10px; border-radius:8px}
  .chart{background:var(--panel); border:1px solid var(--border); border-radius:12px; padding:12px}
  .chart svg{width:100%; height:180px}
  .two-col{display:grid; grid-template-columns:1fr 380px; gap:12px}
  .table{background:var(--panel); border:1px solid var(--border); border-radius:12px; overflow:auto}
  table{width:100%; border-collapse:collapse}
  th, td{padding:10px 12px; border-bottom:1px solid var(--border); text-align:left; font-size:.95rem}
  th{position:sticky; top:0; background:#161a3a; z-index:1; cursor:pointer}
  .payouts{background:var(--panel); border:1px solid var(--border); border-radius:12px; padding:12px; display:flex; flex-direction:column; gap:10px}
  .pill-success{display:inline-block; padding:6px 10px; border-radius:999px; background:rgba(25,214,122,.15); border:1px solid rgba(25,214,122,.45); color:#9ff3cf; font-weight:700}
  .actions{display:flex; gap:8px; flex-wrap:wrap}
  .btn-wide{width:100%}
  .note{color:var(--muted); font-size:.85rem}

  /* JOBS VIEW */
  .jobs-layout{grid-template-columns:1fr; gap:12px;}
  .job-toolbar{display:flex; gap:8px; flex-wrap:wrap; align-items:center}
  .seg{display:inline-flex; background:var(--panel); border:1px solid var(--border); border-radius:999px; overflow:hidden}
  .seg button{padding:8px 12px; border:none; background:transparent; color:var(--muted); font-weight:600; cursor:pointer}
  .seg button.active{background:linear-gradient(135deg,rgba(111,124,255,.18),rgba(154,120,255,.12)); color:var(--text)}
  .joblist{display:grid; gap:10px}
  .jobrow{display:grid; grid-template-columns: 1fr auto; gap:10px; align-items:center; background:var(--panel); border:1px solid var(--border); border-radius:12px; padding:10px}
  .jobrow .meta{color:var(--muted); font-size:.9rem}
  .badge-sm{display:inline-block; padding:4px 8px; border-radius:999px; border:1px solid var(--border); font-size:.8rem; margin-left:6px}
  .status-open{background:rgba(255,204,0,.15); color:#ffe27a; border-color:#ffe27a55}
  .status-active{background:rgba(111,124,255,.15); color:#bdc4ff; border-color:#a8b0ff55}
  .status-done{background:rgba(25,214,122,.15); color:#b8f5db; border-color:#8deec955}
  .status-cancel{background:rgba(255,107,107,.12); color:#ffb3b3; border-color:#ff9a9a55}

  /* INCENTIVES VIEW */
  .incentives-layout{grid-template-columns:1fr; gap:12px;}
  .quest{display:flex; justify-content:space-between; align-items:center; background:var(--panel); border:1px dashed var(--border); border-radius:12px; padding:12px}
  .quest .actions{display:flex; gap:8px}

  /* RATINGS VIEW */
  .ratings-layout{grid-template-columns:1fr; gap:12px;}
  .stars{color:#ffd76b}
  .review{background:var(--panel); border:1px solid var(--border); border-radius:12px; padding:12px}

  /* ACCOUNT VIEW */
  .account-layout{grid-template-columns:1fr 1fr; gap:12px;}
  .field{display:flex; flex-direction:column; gap:6px; margin-bottom:10px}
  .field input,.field select,.field textarea{background:#0f1430; border:1px solid var(--border); color:var(--text); padding:10px; border-radius:8px}
  .docu{background:var(--panel); border:1px dashed var(--border); border-radius:12px; padding:12px}

  /* HELP VIEW */
  .help-layout{grid-template-columns:1fr; gap:12px;}
  details{background:var(--panel); border:1px solid var(--border); border-radius:12px; padding:10px}
  summary{cursor:pointer; font-weight:700}
</style>
</head>
<body>
<form id="form1" runat="server" onsubmit="return false;">
  <div class="app">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="brand"><div class="logo">Ex</div><div><div class="name">ExpandifySA Provider</div><div class="tiny">PC Console</div></div></div>
      <nav class="nav">
        <a href="#" data-view="map"   class="active"><span class="ix">🗺️</span> Map</a>
        <a href="#" data-view="earnings"><span class="ix">💸</span> Earnings</a>
        <a href="#" data-view="jobs" id="btnJobs"><span class="ix">🧰</span> Jobs</a>
        <a href="#" data-view="incentives"><span class="ix">🏆</span> Incentives</a>
        <a href="#" data-view="ratings"><span class="ix">⭐</span> Ratings</a>
        <a href="#" data-view="account"><span class="ix">🛡️</span> Account & Docs</a>
        <a href="#" data-view="help"><span class="ix">❓</span> Help</a>
      </nav>
      <div class="spacer"></div>
      <div class="support tiny">
        Shortcuts: <span class="kbd">O</span> online, <span class="kbd">R</span> request,<br/>
        <span class="kbd">A/D</span> accept/decline, <span class="kbd">E</span> earnings, <span class="kbd">J</span> jobs
      </div>
    </aside>

    <!-- Header -->
    <header class="header">
      <div class="status">
        <div>Status</div>
        <div id="pill" class="pill" role="switch" aria-checked="false" tabindex="0" title="Toggle Online (O)"><div class="dot"></div></div>
        <div id="stateLabel" class="chip">Offline</div>
      </div>
      <div class="hdr-right">
        <div class="chip">Today: <strong>R <span id="earnToday">0</span></strong></div>
        <button id="simulate" class="primary" type="button" title="Simulate Request (R)">Simulate Request</button>
      </div>
    </header>

    <!-- Main (switchable views) -->
    <main class="main">
      <!-- MAP VIEW -->
      <section id="viewMap" class="view map-layout show">
        <section class="map" id="map">
          <div id="ml-map"></div>

          <!-- Radius / location UI -->
          <div class="radius-ui">
            <div class="row">
              <input id="searchBox" type="search" placeholder="Search address or place…" />
              <button id="btnSearch" class="btn" type="button">Search</button>
            </div>
            <div class="row">
              <button id="btnMyLoc" class="btn" type="button">📍 Use my location</button>
              <button id="btnClickSet" class="btn" type="button">👆 Click to set</button>
            </div>
            <div class="row"><small>Service radius (meters)</small></div>
            <div class="row">
              <input id="radiusRange" type="range" min="100" max="10000" step="50" value="1500" />
              <input id="radiusNum" type="number" min="50" max="30000" step="50" value="1500" style="width:110px" />
            </div>
            <div class="row" style="margin-top:4px;">
              <small>Lat: <span id="latLbl">-26.2041</span> • Lng: <span id="lngLbl">28.0473</span></small>
            </div>
          </div>

          <div class="controls">
            <div class="ctrl" id="zoomIn"  title="Zoom In">＋</div>
            <div class="ctrl" id="zoomOut" title="Zoom Out">－</div>
            <div class="ctrl" id="recenter" title="Recenter">🎯</div>
          </div>
          <button id="goBtn" class="go off" type="button">Go Online</button>

          <!-- Incoming request card -->
          <div id="requestCard" class="request" aria-live="polite">
            <div class="badge">🧰 <strong>New Job Request</strong> • <span id="reqTimer">15</span>s</div>
            <div class="req-row">
              <div>
                <div class="req-title">Pickup: 1.2 km • 3 min</div>
                <div class="req-meta"><span>Client: Kamo</span><span>Rating: 4.9★</span></div>
              </div>
              <div class="chip">Est. R <span id="reqFare">48</span></div>
            </div>
            <div class="req-row muted">Task: General Assistance • ~45–60 min</div>
            <div class="req-actions">
              <button id="decline" class="btn danger" type="button" title="Decline (D)">Decline</button>
              <button id="accept" class="btn primary" type="button" title="Accept (A)">Accept</button>
            </div>
          </div>
        </section>

        <!-- Right sidebar -->
        <aside class="panel">
          <div class="row"><h3>Today’s Earnings</h3><div class="chip">Cash out</div></div>
          <div class="earn-num">R <span id="earnBig">0</span></div>
          <div class="progress"><div id="bar" class="bar"></div></div>
          <div class="row muted"><div>Goal: R 600</div><div id="goalPct">0%</div></div>

          <h3>Recent</h3>
          <div id="recent" class="list"><div class="item"><span class="muted">No jobs yet.</span><span>—</span></div></div>

          <h3>Tips & Quests</h3>
          <div class="list">
            <div class="item"><span>🥇 Complete 5 jobs</span><span class="muted">+R60</span></div>
            <div class="item"><span>🔥 Peak hour boost</span><span class="muted">x1.2</span></div>
          </div>
        </aside>
      </section>

      <!-- EARNINGS VIEW -->
      <section id="viewEarnings" class="view earnings-layout">
        <div class="row" style="align-items:center">
          <div class="tabs">
            <button class="tab active" data-range="today" type="button">Today</button>
            <button class="tab" data-range="week" type="button">Week</button>
            <button class="tab" data-range="month" type="button">Month</button>
            <button class="tab" data-range="custom" type="button">Custom</button>
          </div>
          <div class="filters">
            <input type="date" id="fromDate">
            <input type="date" id="toDate">
            <button id="applyCustom" class="btn-ghost" type="button">Apply</button>
            <button id="exportCsv" class="btn-ghost" type="button">Export CSV</button>
          </div>
        </div>

        <section class="kpis">
          <div class="card"><h4>Jobs</h4><div class="big" id="kpiTrips">0</div></div>
          <div class="card"><h4>Active hrs*</h4><div class="big" id="kpiHours">0.0</div></div>
          <div class="card"><h4>Gross</h4><div class="big">R <span id="kpiGross">0</span></div></div>
          <div class="card"><h4>Tips</h4><div class="big">R <span id="kpiTips">0</span></div></div>
          <div class="card"><h4>Fees</h4><div class="big">R <span id="kpiFees">0</span></div></div>
          <div class="card"><h4>Net</h4><div class="big">R <span id="kpiNet">0</span></div></div>
        </section>

        <section class="two-col">
          <div class="table">
            <table id="earnTable">
              <thead>
                <tr>
                  <th data-sort="time">Time</th>
                  <th data-sort="pickup">From</th>
                  <th data-sort="drop">To</th>
                  <th data-sort="dist">Km</th>
                  <th data-sort="dur">Min</th>
                  <th data-sort="fare">Service Fee (R)</th>
                  <th data-sort="tip">Tip (R)</th>
                  <th data-sort="fee">Platform (R)</th>
                  <th data-sort="net">You Get (R)</th>
                </tr>
              </thead>
              <tbody id="earnBody"></tbody>
            </table>
          </div>

          <div class="payouts">
            <div class="row"><h3>Wallet & Cashout</h3><span class="pill-success" id="payoutStatus">Wallet Active</span></div>
            <div class="card">
              <h4>Available to cash out</h4>
              <div class="big">R <span id="availCashout">0</span></div>
              <div class="actions" style="margin-top:10px">
                <button id="cashOut" class="primary btn-wide" type="button">Cash Out</button>
                <button id="refreshEarnings" class="btn-ghost btn-wide" type="button">Refresh</button>
              </div>
              <div class="note" style="margin-top:8px">Cashouts arrive instantly to your linked bank in most cases.</div>
            </div>
            <div class="chart">
              <h3 style="margin:0 0 8px 0">Daily earnings</h3>
              <svg id="earnChart" viewBox="0 0 600 180" preserveAspectRatio="none"></svg>
            </div>
          </div>
        </section>
      </section>

      <!-- JOBS VIEW -->
      <section id="viewJobs" class="view jobs-layout">
        <div class="row job-toolbar">
          <div class="seg" id="jobSeg">
            <button data-filter="all" class="active" type="button">All</button>
            <button data-filter="open" type="button">Open</button>
            <button data-filter="active" type="button">In Progress</button>
            <button data-filter="done" type="button">Completed</button>
            <button data-filter="cancel" type="button">Cancelled</button>
          </div>
          <button id="newJob" class="btn-ghost" type="button">+ Manual Job</button>
          <button id="exportJobs" class="btn-ghost" type="button">Export</button>
          <span class="tiny" id="jobCount">0 jobs</span>
        </div>
        <div id="jobList" class="joblist"></div>
      </section>

      <!-- INCENTIVES VIEW -->
      <section id="viewIncentives" class="view incentives-layout">
        <div class="quest">
          <div>
            <strong>🥇 Complete 5 jobs today</strong>
            <div class="tiny">Bonus: R60 • Progress: <span id="q1Prog">0</span>/5</div>
          </div>
          <div class="actions">
            <button id="trackQ1" class="btn-ghost" type="button">Track</button>
            <button id="claimQ1" class="primary" type="button" disabled>Claim</button>
          </div>
        </div>
        <div class="quest">
          <div>
            <strong>🔥 Peak hour boost</strong>
            <div class="tiny">x1.2 net between 5pm–7pm (auto)</div>
          </div>
          <div class="actions">
            <button id="infoBoost" class="btn-ghost" type="button">Info</button>
          </div>
        </div>
      </section>

      <!-- RATINGS VIEW -->
      <section id="viewRatings" class="view ratings-layout">
        <div class="row">
          <div>
            <h3 style="margin:0">Your Ratings</h3>
            <div class="tiny">Average: <span id="avgStars" class="stars">★★★★★</span> (<span id="avgScore">5.0</span>)</div>
          </div>
          <div class="seg" id="ratingSeg">
            <button data-r="all" class="active" type="button">All</button>
            <button data-r="5" type="button">5★</button>
            <button data-r="4" type="button">4★</button>
            <button data-r="3" type="button">3★</button>
            <button data-r="2" type="button">2★</button>
            <button data-r="1" type="button">1★</button>
          </div>
        </div>
        <div id="reviewList" class="joblist"></div>
      </section>

      <!-- ACCOUNT & DOCS VIEW -->
      <section id="viewAccount" class="view account-layout">
        <div class="card">
          <h3 style="margin:0 0 8px 0">Profile</h3>
          <div class="field"><label>Full name</label><input id="profName" placeholder="e.g., Kamo M." /></div>
          <div class="field"><label>Email</label><input id="profEmail" type="email" placeholder="you@example.com" /></div>
          <div class="field"><label>Mobile</label><input id="profPhone" placeholder="082 123 4567" /></div>
          <div class="field"><label>Services offered</label><input id="profServices" placeholder="Cleaning, Gardening, Handyman" /></div>
          <div class="field"><label>About you</label><textarea id="profAbout" rows="4" placeholder="Short bio to show clients..."></textarea></div>
          <div class="actions"><button id="saveProfile" class="primary" type="button">Save Profile</button><button id="loadProfile" class="btn-ghost" type="button">Load</button></div>
          <div id="saveNote" class="tiny" style="margin-top:6px;color:#9aa0c3">Unsaved changes</div>
        </div>

        <div class="card">
          <h3 style="margin:0 0 8px 0">Documents</h3>
          <div class="docu">
            <div class="field"><label>Identity Document (PDF/JPG)</label><input id="docID" type="file" accept=".pdf,.jpg,.jpeg,.png"/></div>
            <div class="field"><label>Proof of Address</label><input id="docAddress" type="file" accept=".pdf,.jpg,.jpeg,.png"/></div>
            <div class="field"><label>Certificates (optional)</label><input id="docCert" type="file" multiple accept=".pdf,.jpg,.jpeg,.png"/></div>
            <div class="actions"><button id="uploadDocs" class="primary" type="button">Upload</button></div>
            <div id="docStatus" class="tiny" style="margin-top:6px;color:#9aa0c3">No uploads yet.</div>
          </div>

          <h3 style="margin:12px 0 8px 0">Payout details</h3>
          <div class="field"><label>Bank</label>
            <select id="bankSel">
              <option value="">Select Bank</option><option>FNB</option><option>ABSA</option><option>Standard Bank</option><option>Nedbank</option><option>Capitec</option><option>TymeBank</option><option>Discovery Bank</option><option>African Bank</option>
            </select>
          </div>
          <div class="field"><label>Account number</label><input id="bankAcc" /></div>
          <div class="actions"><button id="saveBank" class="btn-ghost" type="button">Save Bank</button></div>
          <div id="bankNote" class="tiny" style="margin-top:6px;color:#9aa0c3">Not linked.</div>
        </div>
      </section>

      <!-- HELP VIEW -->
      <section id="viewHelp" class="view help-layout">
        <details open>
          <summary>How do I go online and receive job requests?</summary>
          <div class="tiny" style="margin-top:6px">Use the status switch at the top (or press <b>O</b>). Click “Simulate Request” to test the flow.</div>
        </details>
        <details>
          <summary>How is my service area set?</summary>
          <div class="tiny" style="margin-top:6px">Search or set a pin on the map. Adjust the radius slider to control how far jobs can be.</div>
        </details>
        <details>
          <summary>How do payments work?</summary>
          <div class="tiny" style="margin-top:6px">Earnings accumulate in your in-app wallet. Link your bank under Account & Docs, then cash out from Earnings.</div>
        </details>
        <div class="row">
          <button id="contactSupport" class="primary" type="button">Contact Support</button>
          <button id="openDocs" class="btn-ghost" type="button">Platform Docs</button>
        </div>
      </section>
    </main>
  </div>

  <!-- Jobs drawer -->
  <div id="drawer" class="drawer" aria-hidden="true">
    <div class="row"><h3>Job Activity (Today)</h3><button id="closeDrawer" class="primary" type="button">Close</button></div>
    <div id="jobDrawerList"></div>
  </div>
</form>

<!-- JS libs -->
<script src="https://unpkg.com/maplibre-gl@3.6.1/dist/maplibre-gl.js"></script>
<script src="https://unpkg.com/maplibre-gl-gesture-handling"></script>
<script async defer src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_API_KEY&libraries=places"></script>

<script>
  // ===== Simple router between views =====
  const views = {
    map: document.getElementById('viewMap'),
    earnings: document.getElementById('viewEarnings'),
    jobs: document.getElementById('viewJobs'),
    incentives: document.getElementById('viewIncentives'),
    ratings: document.getElementById('viewRatings'),
    account: document.getElementById('viewAccount'),
    help: document.getElementById('viewHelp')
  };
  const navLinks = document.querySelectorAll('.nav a[data-view]');
  function showView(name){
    navLinks.forEach(a => a.classList.toggle('active', a.dataset.view === name));
    Object.entries(views).forEach(([k,el]) => el.classList.toggle('show', k===name));
  }
  navLinks.forEach(a => a.addEventListener('click', (e)=>{ e.preventDefault(); showView(a.dataset.view); }));

  // ===== Provider state & stores =====
  let online = false, earnings = 0, goal = 600, timerId = null, timerLeft = 0, reqVisible = false, seq = 1;
  const jobs = []; // {id,time,client,from,to,km,min,fare,tip,fee,net,status}
  const reviews = [
    { id:1, stars:5, text:'Great service! Very professional.', when:new Date() },
    { id:2, stars:5, text:'On time and friendly.', when:new Date(Date.now()-86400000) },
    { id:3, stars:4, text:'Good job, minor delay.', when:new Date(Date.now()-2*86400000) },
  ];

  // Header refs
  const pill = document.getElementById('pill');
  const stateLabel = document.getElementById('stateLabel');
  const goBtn = document.getElementById('goBtn');
  const earnToday = document.getElementById('earnToday');
  const earnBig = document.getElementById('earnBig');
  const bar = document.getElementById('bar');
  const goalPct = document.getElementById('goalPct');
  const simulate = document.getElementById('simulate');

  // Map-side “recent” and drawer
  const requestCard = document.getElementById('requestCard');
  const reqTimer = document.getElementById('reqTimer');
  const reqFare = document.getElementById('reqFare');
  const recent = document.getElementById('recent');
  const drawer = document.getElementById('drawer');
  const jobDrawerList = document.getElementById('jobDrawerList');
  const closeDrawer = document.getElementById('closeDrawer');

  // Earnings refs
  const tabButtons = document.querySelectorAll('.tab');
  const fromDate = document.getElementById('fromDate');
  const toDate = document.getElementById('toDate');
  const applyCustom = document.getElementById('applyCustom');
  const exportCsv = document.getElementById('exportCsv');
  const kpiTrips = document.getElementById('kpiTrips');
  const kpiHours = document.getElementById('kpiHours');
  const kpiGross = document.getElementById('kpiGross');
  const kpiTips  = document.getElementById('kpiTips');
  const kpiFees  = document.getElementById('kpiFees');
  const kpiNet   = document.getElementById('kpiNet');
  const availCashout = document.getElementById('availCashout');
  const earnBody = document.getElementById('earnBody');
  const earnTable = document.getElementById('earnTable');
  const earnChart = document.getElementById('earnChart');
  const refreshEarnings = document.getElementById('refreshEarnings');
  const cashOut = document.getElementById('cashOut');

  // Jobs refs
  const jobSeg = document.getElementById('jobSeg');
  const jobList = document.getElementById('jobList');
  const jobCount = document.getElementById('jobCount');
  const newJob = document.getElementById('newJob');
  const exportJobs = document.getElementById('exportJobs');

  // Incentives refs
  const q1Prog = document.getElementById('q1Prog');
  const claimQ1 = document.getElementById('claimQ1');
  const trackQ1 = document.getElementById('trackQ1');
  const infoBoost = document.getElementById('infoBoost');

  // Ratings refs
  const ratingSeg = document.getElementById('ratingSeg');
  const reviewList = document.getElementById('reviewList');
  const avgStars = document.getElementById('avgStars');
  const avgScore = document.getElementById('avgScore');

  // Account refs
  const profName = document.getElementById('profName');
  const profEmail = document.getElementById('profEmail');
  const profPhone = document.getElementById('profPhone');
  const profServices = document.getElementById('profServices');
  const profAbout = document.getElementById('profAbout');
  const saveProfile = document.getElementById('saveProfile');
  const loadProfile = document.getElementById('loadProfile');
  const saveNote = document.getElementById('saveNote');
  const docID = document.getElementById('docID');
  const docAddress = document.getElementById('docAddress');
  const docCert = document.getElementById('docCert');
  const uploadDocs = document.getElementById('uploadDocs');
  const docStatus = document.getElementById('docStatus');
  const bankSel = document.getElementById('bankSel');
  const bankAcc = document.getElementById('bankAcc');
  const saveBank = document.getElementById('saveBank');
  const bankNote = document.getElementById('bankNote');

  // Help refs
  const contactSupport = document.getElementById('contactSupport');
  const openDocs = document.getElementById('openDocs');

  // ===== Online toggle & header =====
  function setOnline(val){
    online = val;
    pill.classList.toggle('online', online);
    pill.setAttribute('aria-checked', online);
    stateLabel.textContent = online ? 'Online' : 'Offline';
    goBtn.textContent = online ? 'You are Online' : 'Go Online';
    goBtn.classList.toggle('off', !online);
    if (online) safePost('/api/provider/prefs', { lng: Number(lngLbl.textContent), lat: Number(latLbl.textContent), radius_m: getRadius() });
  }
  function updateHeaderEarnings(){
    const net = jobs.filter(j=>j.status==='done').reduce((a,j)=>a+j.net,0);
    earnToday.textContent = net.toFixed(0);
    earnBig.textContent = net.toFixed(0);
    const pct = Math.min(100, (net/goal)*100);
    bar.style.width = pct.toFixed(0) + '%';
    goalPct.textContent = pct.toFixed(0) + '%';
  }
  function addRecent(text, amount){
    if (recent.firstElementChild && recent.firstElementChild.textContent.includes('No jobs')) recent.innerHTML = '';
    const el = document.createElement('div'); el.className = 'item'; el.innerHTML = `<span>${text}</span><span>R ${amount}</span>`; recent.prepend(el);
  }

  // ===== Simulated request flow =====
  function openRequest(){
    if (!online) return;
    reqVisible = true; requestCard.classList.add('show'); timerLeft = 15;
    reqTimer.textContent = timerLeft; reqFare.textContent = (60 + Math.round(Math.random()*90)).toString();
    timerId = setInterval(()=>{ timerLeft--; reqTimer.textContent = timerLeft; if (timerLeft <= 0) { closeRequest(); addRecent('Missed job', '0'); }},1000);
  }
  function closeRequest(){ reqVisible = false; requestCard.classList.remove('show'); if (timerId) { clearInterval(timerId); timerId = null; } }
  function accept(){
    if (!reqVisible) return;
    closeRequest();
    const fare = Number(reqFare.textContent);
    const tip  = Math.random() < 0.35 ? Math.round(Math.random()*20) : 0;
    const fee  = Math.round(fare * 0.15);
    const net  = fare + tip - fee;

    const j = {
      id: seq++,
      time: new Date(),
      client: 'Kamo',
      from: 'CBD',
      to: 'Sandton',
      km: (5 + Math.random()*8).toFixed(1),
      min: (40 + Math.random()*25).toFixed(0),
      fare, tip, fee, net,
      status: 'done'
    };
    jobs.push(j);

    updateHeaderEarnings();
    addRecent(`Job completed • #${j.id}`, net);
    addJobToDrawer(j);
    recalcAndRender(); // Earnings view
    renderJobs();      // Jobs view
    updateIncentives();
  }
  function decline(){ if (!reqVisible) return; closeRequest(); addRecent('Declined job', '0'); }
  function addJobToDrawer(j){
    const div = document.createElement('div'); div.className = 'job';
    const now = j.time.toLocaleTimeString();
    div.innerHTML = `<div class="row"><strong>Job #${j.id}</strong><span class="muted">${now}</span></div>
                     <div class="row"><span>${j.km} km • ${j.min} min • ${j.from} → ${j.to}</span><span><strong>R ${j.net}</strong></span></div>`;
    jobDrawerList.prepend(div);
  }

  document.getElementById('btnJobs').addEventListener('click', (e)=>{ e.preventDefault(); showView('jobs'); });

  // Hooks
  document.getElementById('accept').addEventListener('click', accept);
  document.getElementById('decline').addEventListener('click', decline);
  closeDrawer.addEventListener('click', ()=>{ drawer.classList.remove('show'); drawer.setAttribute('aria-hidden','true'); });
  pill.addEventListener('click', ()=> setOnline(!online));
  pill.addEventListener('keydown', (e)=>{ if(e.key==='Enter' || e.key===' ') { e.preventDefault(); setOnline(!online);} });
  goBtn.addEventListener('click', ()=> setOnline(!online));
  simulate.addEventListener('click', openRequest);
  window.addEventListener('keydown', (e)=>{ const k = e.key.toLowerCase();
    if (k==='o') setOnline(!online);
    if (k==='r') openRequest();
    if (k==='a') accept();
    if (k==='d') decline();
    if (k==='e') showView('earnings');
    if (k==='j') showView('jobs');
  });

  setOnline(false); updateHeaderEarnings();

  // ===== Map & location/radius =====
  const startCenter = [28.0473, -26.2041]; // Johannesburg
  const map = new maplibregl.Map({
    container: 'ml-map',
    style: { version: 8, sources: { 'osm-tiles': { type: 'raster', tiles: ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'], tileSize: 256, attribution: '© OpenStreetMap' } }, layers: [{ id: 'base', type: 'raster', source: 'osm-tiles' }] },
    center: startCenter, zoom: 12
  });
  map.touchZoomRotate.enable(); map.touchZoomRotate.enableRotation(); map.dragPan.enable();
  map.addControl(new GestureHandling({ text: { touch: 'Use two fingers to move the map', scroll: 'Use Ctrl + scroll to zoom the map' }}));

  // Google Places Autocomplete
  window.initPlaces = function initPlaces(){
    const input = document.getElementById('searchBox');
    const ac = new google.maps.places.Autocomplete(input, { fields: ['geometry','name','place_id','formatted_address'], componentRestrictions: { country: ['za'] }});
    ac.addListener('place_changed', ()=>{
      const place = ac.getPlace(); if (!place.geometry || !place.geometry.location) return;
      const lat = place.geometry.location.lat(), lng = place.geometry.location.lng();
      marker.setLngLat([lng,lat]); updateLatLng(lng,lat); drawCircle(); map.flyTo({center:[lng,lat], zoom:14});
    });
  };
  const waitForGoogle = setInterval(()=>{ if (window.google && google.maps && google.maps.places) { clearInterval(waitForGoogle); initPlaces(); }}, 100);

  // Map UI refs
  const latLbl = document.getElementById('latLbl');
  const lngLbl = document.getElementById('lngLbl');
  const radiusRange = document.getElementById('radiusRange');
  const radiusNum = document.getElementById('radiusNum');
  const btnMyLoc = document.getElementById('btnMyLoc');
  const btnClickSet = document.getElementById('btnClickSet');
  const btnSearch  = document.getElementById('btnSearch');
  const searchBox  = document.getElementById('searchBox');
  const zoomIn = document.getElementById('zoomIn');
  const zoomOut = document.getElementById('zoomOut');
  const recenter = document.getElementById('recenter');

  function getRadius(){ return Number(radiusNum.value || 1500); }

  // Marker + radius circle
  const markerEl = document.createElement('div');
  markerEl.style.width='24px'; markerEl.style.height='24px'; markerEl.style.borderRadius='50%';
  markerEl.style.background='linear-gradient(135deg,#6f7cff,#9a78ff)'; markerEl.style.boxShadow='0 0 0 4px rgba(111,124,255,.25)';
  const marker = new maplibregl.Marker({element: markerEl, draggable:true}).setLngLat(startCenter).addTo(map);
  marker.on('dragend', ()=> { const c = marker.getLngLat(); updateLatLng(c.lng, c.lat); drawCircle(); });

  map.on('load', ()=>{
    map.addSource('radius-circle', { type:'geojson', data: circleGeoJSON(marker.getLngLat(), getRadius()) });
    map.addLayer({ id:'radius-fill', type:'fill', source:'radius-circle', paint:{ 'fill-color':'#6f7cff', 'fill-opacity':0.15 } });
    map.addLayer({ id:'radius-outline', type:'line', source:'radius-circle', paint:{ 'line-color':'#9a78ff', 'line-width':2, 'line-opacity':0.9 } });
    updateLatLng(startCenter[0], startCenter[1]);
  });

  function circleGeoJSON(center, radiusMeters, points=64){
    const R = 6371008.8; const lng = center.lng !== undefined ? center.lng : center[0]; const lat = center.lat !== undefined ? center.lat : center[1];
    const coords = []; const angDist = radiusMeters / R; const lat1 = lat * Math.PI/180; const lng1 = lng * Math.PI/180;
    for (let i=0;i<=points;i++){ const brng = (i/points) * 2*Math.PI;
      const lat2 = Math.asin(Math.sin(lat1)*Math.cos(angDist) + Math.cos(lat1)*Math.sin(angDist)*Math.cos(brng));
      const lng2 = lng1 + Math.atan2(Math.sin(brng)*Math.sin(angDist)*Math.cos(lat1), Math.cos(angDist)-Math.sin(lat1)*Math.sin(lat2));
      coords.push([ (lng2*180/Math.PI), (lat2*180/Math.PI) ]);
    }
    return { type:'FeatureCollection', features:[{ type:'Feature', geometry:{ type:'Polygon', coordinates:[coords] } }] };
  }
  function drawCircle(){ const src = map.getSource('radius-circle'); if (!src) return; src.setData( circleGeoJSON(marker.getLngLat(), getRadius()) ); }
  function updateLatLng(lng, lat){ lngLbl.textContent = Number(lng).toFixed(6); latLbl.textContent = Number(lat).toFixed(6); }

  radiusRange.addEventListener('input', ()=>{ radiusNum.value = radiusRange.value; drawCircle(); });
  radiusNum.addEventListener('input', ()=>{ radiusRange.value = radiusNum.value; drawCircle(); });

  btnMyLoc.addEventListener('click', ()=>{
    if (!navigator.geolocation) { alert('Geolocation not supported'); return; }
    navigator.geolocation.getCurrentPosition(pos=>{
      const {longitude:lng, latitude:lat} = pos.coords;
      marker.setLngLat([lng,lat]); updateLatLng(lng,lat); drawCircle(); map.flyTo({center:[lng,lat], zoom:14});
    }, err=> alert('Unable to get location: ' + err.message), {enableHighAccuracy:true, timeout:8000, maximumAge:0});
  });

  let clickMode = false;
  btnClickSet.addEventListener('click', ()=>{ clickMode = !clickMode; btnClickSet.textContent = clickMode ? '✅ Click to set (on)' : '👆 Click to set'; btnClickSet.style.borderColor = clickMode ? 'var(--accent)' : 'var(--border)'; });
  map.on('click', (e)=>{ if (!clickMode) return; const {lng,lat} = e.lngLat; marker.setLngLat([lng,lat]); updateLatLng(lng,lat); drawCircle(); });

  zoomIn.onclick  = ()=> map.zoomTo(map.getZoom()+1, {duration:250});
  zoomOut.onclick = ()=> map.zoomTo(map.getZoom()-1, {duration:250});
  recenter.onclick= ()=> map.flyTo({center:marker.getLngLat(), zoom:14});

  btnSearch.addEventListener('click', ()=>{
    if (window.google && google.maps && google.maps.places) {
      const svc = new google.maps.places.PlacesService(document.createElement('div'));
      svc.textSearch({ query: searchBox.value, region: 'ZA' }, (results, status)=>{
        if (status !== google.maps.places.PlacesServiceStatus.OK || !results.length) { alert('No results'); return; }
        const p = results[0].geometry.location; const lat = p.lat(), lng = p.lng();
        marker.setLngLat([lng,lat]); updateLatLng(lng,lat); drawCircle(); map.flyTo({center:[lng,lat], zoom:14});
      });
    } else {
      alert('Places not ready. Check your API key.');
    }
  });
  searchBox.addEventListener('keydown', (e)=>{ if(e.key==='Enter'){ e.preventDefault(); btnSearch.click(); } });

  // ===== Earnings logic =====
  function startOfToday(){ const d = new Date(); d.setHours(0,0,0,0); return d; }
  function endOfToday(){ const d = new Date(); d.setHours(23,59,59,999); return d; }
  function startOfWeek(){ const d = new Date(); const day = (d.getDay()+6)%7; d.setHours(0,0,0,0); d.setDate(d.getDate()-day); return d; }
  function endOfWeek(){ const s = startOfWeek(); const e = new Date(s); e.setDate(s.getDate()+6); e.setHours(23,59,59,999); return e; }
  function startOfMonth(){ const d = new Date(); d.setDate(1); d.setHours(0,0,0,0); return d; }
  function endOfMonth(){ const d = new Date(); d.setMonth(d.getMonth()+1,0); d.setHours(23,59,59,999); return d; }

  let currentRange = 'today';
  function setRange(range){
    currentRange = range;
    tabButtons.forEach(b=> b.classList.toggle('active', b.dataset.range===range));
    if (range !== 'custom') { fromDate.value = ''; toDate.value = ''; }
    recalcAndRender();
  }
  tabButtons.forEach(b => b.addEventListener('click', ()=> setRange(b.dataset.range)));
  applyCustom.addEventListener('click', ()=> setRange('custom'));
  refreshEarnings.addEventListener('click', recalcAndRender);

  function currentBounds(){
    if (currentRange==='today') return [startOfToday(), endOfToday()];
    if (currentRange==='week')  return [startOfWeek(), endOfWeek()];
    if (currentRange==='month') return [startOfMonth(), endOfMonth()];
    if (currentRange==='custom'){
      if (!fromDate.value || !toDate.value) return [new Date(0), new Date()];
      const s = new Date(fromDate.value + 'T00:00:00'); const e = new Date(toDate.value + 'T23:59:59');
      return [s,e];
    }
    return [new Date(0), new Date()];
  }
  function recalcAndRender(){
    const [s,e] = currentBounds();
    const sel = jobs.filter(j => j.status==='done' && j.time >= s && j.time <= e);

    const count = sel.length;
    const gross = sel.reduce((a,t)=>a+t.fare,0);
    const tips  = sel.reduce((a,t)=>a+t.tip,0);
    const fees  = sel.reduce((a,t)=>a+t.fee,0);
    const net   = sel.reduce((a,t)=>a+t.net,0);
    const hours = Math.max( (count * 50) / 60, online ? 0.2 : 0 ); // ~50min avg job

    kpiTrips.textContent = count;
    kpiGross.textContent = gross.toFixed(0);
    kpiTips.textContent  = tips.toFixed(0);
    kpiFees.textContent  = fees.toFixed(0);
    kpiNet.textContent   = net.toFixed(0);
    kpiHours.textContent = hours.toFixed(1);
    availCashout.textContent = net.toFixed(0);

    earnBody.innerHTML = sel.map(t => `
      <tr>
        <td>${t.time.toLocaleString()}</td>
        <td>${t.from}</td>
        <td>${t.to}</td>
        <td>${t.km}</td>
        <td>${t.min}</td>
        <td>${t.fare}</td>
        <td>${t.tip}</td>
        <td>${t.fee}</td>
        <td>${t.net}</td>
      </tr>
    `).join('') || `<tr><td colspan="9" class="muted" style="text-align:center;padding:16px">No jobs in this period.</td></tr>`;

    drawBarChart(bucketByDay(sel));
    updateHeaderEarnings();
  }
  function bucketByDay(list){
    const m = new Map();
    list.forEach(t=>{
      const d = new Date(t.time.getFullYear(), t.time.getMonth(), t.time.getDate());
      const k = d.toISOString().slice(0,10);
      m.set(k, (m.get(k)||0) + t.net);
    });
    const [s,e] = currentBounds();
    const days = []; const cur = new Date(s); cur.setHours(0,0,0,0); const end = new Date(e); end.setHours(0,0,0,0);
    while (cur <= end){ const k = cur.toISOString().slice(0,10); days.push({ day:k, value: m.get(k)||0 }); cur.setDate(cur.getDate()+1); }
    return days;
  }
  function drawBarChart(data){
    const w = 600, h = 180, pad = 24;
    const max = Math.max(50, ...data.map(d=>d.value));
    const barW = Math.max(4, (w - pad*2) / Math.max(1,data.length) - 4);
    const bars = data.map((d,i)=>{
      const x = pad + i*((w - pad*2)/Math.max(1,data.length)) + 2;
      const y = h - pad - (d.value / max) * (h - pad*2);
      const height = h - pad - y;
      const label = d.day.slice(5);
      return `<rect x="${x}" y="${y}" width="${barW}" height="${height}" rx="4" />
              <text x="${x + barW/2}" y="${h-6}" font-size="10" text-anchor="middle" fill="#9aa0c3">${label}</text>`;
    }).join('');
    earnChart.innerHTML = `
      <defs><linearGradient id="g1" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#9a78ff"/><stop offset="100%" stop-color="#6f7cff"/></linearGradient></defs>
      <rect x="0" y="0" width="${w}" height="${h}" fill="transparent"/>
      <g fill="url(#g1)" stroke="rgba(154,120,255,.15)">${bars}</g>`;
  }
  // sort columns
  let sortKey = 'time', sortAsc = false;
  earnTable.querySelectorAll('th[data-sort]').forEach(th=>{
    th.addEventListener('click', ()=>{
      const key = th.dataset.sort;
      if (sortKey === key) sortAsc = !sortAsc; else { sortKey = key; sortAsc = true; }
      const [s,e] = currentBounds();
      const sel = jobs.filter(t => t.status==='done' && t.time >= s && t.time <= e);
      sel.sort((a,b)=>{
        const va = key==='time' ? a.time : (key==='from'?a.from:(key==='to'?a.to:Number(a[key])));
        const vb = key==='time' ? b.time : (key==='from'?b.from:(key==='to'?b.to:Number(b[key])));
        if (va<vb) return sortAsc?-1:1; if (va>vb) return sortAsc?1:-1; return 0;
      });
      earnBody.innerHTML = sel.map(t => `
        <tr>
          <td>${t.time.toLocaleString()}</td>
          <td>${t.from}</td>
          <td>${t.to}</td>
          <td>${t.km}</td>
          <td>${t.min}</td>
          <td>${t.fare}</td>
          <td>${t.tip}</td>
          <td>${t.fee}</td>
          <td>${t.net}</td>
        </tr>`).join('');
    });
  });
  exportCsv.addEventListener('click', ()=>{
    const [s,e] = currentBounds();
    const sel = jobs.filter(t => t.status==='done' && t.time >= s && t.time <= e);
    const rows = [['Time','From','To','Km','Min','ServiceFee','Tip','Platform','YouGet'], ...sel.map(t => [t.time.toISOString(), t.from, t.to, t.km, t.min, t.fare, t.tip, t.fee, t.net])];
    const csv = rows.map(r => r.map(v => `"${String(v).replace(/"/g,'""')}"`).join(',')).join('\n');
    const blob = new Blob([csv], {type:'text/csv;charset=utf-8;'}); const url = URL.createObjectURL(blob);
    const a = document.createElement('a'); a.href=url; a.download=`earnings_${currentRange}.csv`; a.click(); URL.revokeObjectURL(url);
  });
  cashOut.addEventListener('click', async ()=>{
    const amount = Number(availCashout.textContent||'0'); if (!amount) { alert('Nothing to cash out yet.'); return; }
    try{ await fetch('/api/payouts/cashout', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({ amount }) }); alert('Cash out submitted ✅'); }
    catch(e){ alert('Cash out failed.'); }
  });

  // ===== Jobs view =====
  let jobFilter = 'all';
  jobSeg.querySelectorAll('button').forEach(b=> b.addEventListener('click', ()=>{ jobSeg.querySelectorAll('button').forEach(x=>x.classList.remove('active')); b.classList.add('active'); jobFilter = b.dataset.filter; renderJobs(); }));
  function renderJobs(){
    const list = jobs
      .filter(j => jobFilter==='all' ? true : j.status===jobFilter)
      .sort((a,b)=>b.time-a.time);
    jobCount.textContent = `${list.length} job${list.length!==1?'s':''}`;
    jobList.innerHTML = list.map(j => {
      const badge = j.status==='open' ? 'status-open' : j.status==='active' ? 'status-active' : j.status==='done' ? 'status-done' : 'status-cancel';
      return `<div class="jobrow">
        <div>
          <strong>#${j.id} • ${j.client}</strong>
          <span class="badge-sm ${badge}">${j.status.toUpperCase()}</span>
          <div class="meta">${j.time.toLocaleString()} • ${j.from} → ${j.to} • ${j.km} km • ${j.min} min</div>
        </div>
        <div class="actions">
          ${j.status!=='done' && j.status!=='cancel' ? `<button class="btn-ghost" type="button" data-act="start" data-id="${j.id}">Start</button>`:''}
          ${j.status==='active' ? `<button class="primary" type="button" data-act="complete" data-id="${j.id}">Complete</button>`:''}
          ${j.status!=='cancel' && j.status!=='done' ? `<button class="btn-ghost" type="button" data-act="cancel" data-id="${j.id}">Cancel</button>`:''}
        </div>
      </div>`;
    }).join('') || `<div class="tiny muted">No jobs here yet.</div>`;

    jobList.querySelectorAll('button[data-act]').forEach(btn=>{
      btn.addEventListener('click', ()=>{
        const id = Number(btn.dataset.id); const act = btn.dataset.act;
        const j = jobs.find(x=>x.id===id); if (!j) return;
        if (act==='start') j.status = 'active';
        if (act==='cancel') j.status = 'cancel';
        if (act==='complete'){
          j.status = 'done';
          updateHeaderEarnings(); recalcAndRender(); updateIncentives();
          addRecent(`Job completed • #${j.id}`, j.net);
          addJobToDrawer(j);
        }
        renderJobs();
      });
    });
  }
  newJob.addEventListener('click', ()=>{
    const fare = 50 + Math.round(Math.random()*120);
    const tip = 0, fee = Math.round(fare*0.15), net = fare - fee;
    const j = { id: seq++, time: new Date(), client:'Manual', from:'Custom A', to:'Custom B', km:(3+Math.random()*4).toFixed(1), min:(30+Math.random()*20).toFixed(0), fare, tip, fee, net, status:'open' };
    jobs.push(j); renderJobs();
  });
  exportJobs.addEventListener('click', ()=>{
    const list = jobs.filter(j => jobFilter==='all' ? true : j.status===jobFilter).sort((a,b)=>a.id-b.id);
    const rows = [['ID','When','Client','From','To','Km','Min','Fare','Tip','Fee','Net','Status'], ...list.map(j=>[j.id, j.time.toISOString(), j.client, j.from, j.to, j.km, j.min, j.fare, j.tip, j.fee, j.net, j.status])];
    const csv = rows.map(r => r.map(v => `"${String(v).replace(/"/g,'""')}"`).join(',')).join('\n');
    const blob = new Blob([csv], {type:'text/csv;charset=utf-8;'}); const url = URL.createObjectURL(blob);
    const a = document.createElement('a'); a.href=url; a.download=`jobs_${jobFilter}.csv`; a.click(); URL.revokeObjectURL(url);
  });

  // ===== Incentives =====
  function updateIncentives(){
    const todayDone = jobs.filter(j=> j.status==='done' && isSameDay(j.time, new Date())).length;
    q1Prog.textContent = todayDone;
    claimQ1.disabled = todayDone < 5;
  }
  trackQ1.addEventListener('click', ()=>{ showView('jobs'); alert('Tracking: complete 5 jobs today to claim R60.'); });
  claimQ1.addEventListener('click', ()=>{ if (!claimQ1.disabled) { alert('Bonus R60 added to your wallet!'); } });
  infoBoost.addEventListener('click', ()=> alert('Between 17:00–19:00, completed jobs get a 1.2x net boost automatically.'));

  function isSameDay(a,b){ return a.getFullYear()===b.getFullYear() && a.getMonth()===b.getMonth() && a.getDate()===b.getDate(); }

  // ===== Ratings =====
  function renderRatings(filter='all'){
    const list = reviews.filter(r => filter==='all' ? true : r.stars===Number(filter));
    reviewList.innerHTML = list.map(r => `
      <div class="review">
        <div><span class="stars">${'★'.repeat(r.stars)}${'☆'.repeat(5-r.stars)}</span> • <span class="tiny muted">${r.when.toLocaleString()}</span></div>
        <div style="margin-top:6px">${r.text}</div>
      </div>`).join('') || `<div class="tiny muted">No reviews yet.</div>`;
    const avg = (reviews.reduce((a,r)=>a+r.stars,0) / (reviews.length||1)).toFixed(1);
    avgScore.textContent = avg;
    const rounded = Math.round(avg);
    avgStars.textContent = '★'.repeat(rounded) + '☆'.repeat(5-rounded);
  }
  ratingSeg.querySelectorAll('button').forEach(b=> b.addEventListener('click', ()=>{ ratingSeg.querySelectorAll('button').forEach(x=>x.classList.remove('active')); b.classList.add('active'); renderRatings(b.dataset.r); }));

  // ===== Account & Docs =====
  function saveProfileToLocal(){
    const data = {
      name: profName.value, email: profEmail.value, phone: profPhone.value,
      services: profServices.value, about: profAbout.value,
      bank: bankSel.value, acc: bankAcc.value
    };
    localStorage.setItem('expandify_profile', JSON.stringify(data));
    saveNote.textContent = 'Saved ✓';
  }
  function loadProfileFromLocal(){
    const raw = localStorage.getItem('expandify_profile'); if (!raw) { saveNote.textContent='Nothing saved yet.'; return; }
    try{
      const d = JSON.parse(raw);
      profName.value = d.name||''; profEmail.value = d.email||''; profPhone.value = d.phone||'';
      profServices.value = d.services||''; profAbout.value = d.about||'';
      bankSel.value = d.bank||''; bankAcc.value = d.acc||'';
      saveNote.textContent = 'Loaded ✓';
      bankNote.textContent = d.bank ? ('Linked: ' + d.bank) : 'Not linked.';
    }catch(e){ saveNote.textContent = 'Load failed'; }
  }
  saveProfile.addEventListener('click', saveProfileToLocal);
  loadProfile.addEventListener('click', loadProfileFromLocal);
  uploadDocs.addEventListener('click', ()=>{
    const idOk = docID.files.length>0, addrOk = docAddress.files.length>0;
    const certs = docCert.files.length;
    docStatus.textContent = (idOk||addrOk||certs) ? 'Uploaded ✓ (pending verification)' : 'No uploads yet.';
  });
  saveBank.addEventListener('click', ()=>{ saveProfileToLocal(); bankNote.textContent = bankSel.value ? ('Linked: ' + bankSel.value) : 'Not linked.'; });

  // ===== Help =====
  contactSupport.addEventListener('click', ()=> { window.location.href = 'mailto:support@expandifysa.co.za?subject=Support%20Request'; });
  openDocs.addEventListener('click', ()=> { alert('Open platform docs: (link your docs URL here)'); });

  // ===== Utils =====
  async function safePost(url, body){
    try{ await fetch(url, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(body) }); }
    catch(e){ /* no-op */ }
  }

  // Initial view/state
  showView('map');
  setRange('today');
  recalcAndRender();
  renderJobs();
  renderRatings('all');
  updateIncentives();
</script>
</body>
</html>
