<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expandify SA - Uplifting Small Businesses</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
        }

        /* Loader Styles */
        .loader-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.8s ease, visibility 0.8s ease;
        }

        .loader-container.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-content {
            text-align: center;
        }

        .brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 4rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 1rem;
            opacity: 0;
            animation: fadeInUp 0.8s ease forwards;
        }

        .brand-slogan {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 300;
            letter-spacing: 1px;
            opacity: 0;
            animation: fadeInUp 0.8s ease forwards 2s;
            margin-bottom: 3rem;
        }

        .dots-container {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 2rem;
        }

        .dot {
            width: 18px;
            height: 18px;
            background-color: #ffffff;
            border-radius: 50%;
            animation: bounce 1.4s infinite ease-in-out;
        }

        .dot:nth-child(1) {
            animation-delay: 0s;
        }

        .dot:nth-child(2) {
            animation-delay: 0.2s;
        }

        .dot:nth-child(3) {
            animation-delay: 0s;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes bounce {
            0%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-25px);
            }
        }

        /* Main Landing Page Styles */
        .main-content {
            opacity: 0;
            transition: opacity 1s ease;
        }

        .main-content.visible {
            opacity: 1;
        }

        /* Hero Section */
        .hero-section {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><defs><pattern id="grid" width="100" height="100" patternUnits="userSpaceOnUse"><path d="M 100 0 L 0 0 0 100" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="1"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>');
            opacity: 0.3;
        }

        .navbar {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            padding: 2rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 100;
        }

        .logo {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 700;
            color: #ffffff;
        }

        .nav-links {
            display: flex;
            gap: 3rem;
            list-style: none;
        }

        .nav-links a {
            color: #ffffff;
            text-decoration: none;
            font-weight: 400;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: #ffffff;
            transition: width 0.3s ease;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        .hero-content {
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 5%;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 4rem;
        }

        .hero-text {
            flex: 1;
            color: #ffffff;
        }

        .hero-text h1 {
            font-family: 'Playfair Display', serif;
            font-size: 4.5rem;
            font-weight: 700;
            line-height: 1.2;
            margin-bottom: 1.5rem;
        }

        .hero-text p {
            font-size: 1.3rem;
            line-height: 1.8;
            margin-bottom: 2.5rem;
            opacity: 0.95;
        }

        .cta-buttons {
            display: flex;
            gap: 1.5rem;
        }

        .btn {
            padding: 1rem 2.5rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-block;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background: #ffffff;
            color: #667eea;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
        }

        .btn-secondary {
            background: transparent;
            color: #ffffff;
            border: 2px solid #ffffff;
        }

        .btn-secondary:hover {
            background: #ffffff;
            color: #667eea;
            transform: translateY(-3px);
        }

        .hero-visual {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .visual-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transform: perspective(1000px) rotateY(-10deg);
            transition: all 0.5s ease;
        }

        .visual-card:hover {
            transform: perspective(1000px) rotateY(0deg);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
        }

        .stat-item {
            text-align: center;
            color: #ffffff;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            font-family: 'Playfair Display', serif;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
            margin-top: 0.5rem;
        }

        /* Features Section */
        .features-section {
            padding: 8rem 5%;
            background: #ffffff;
        }

        .section-header {
            text-align: center;
            max-width: 700px;
            margin: 0 auto 5rem;
        }

        .section-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            color: #2d3748;
            margin-bottom: 1rem;
        }

        .section-header p {
            font-size: 1.2rem;
            color: #718096;
            line-height: 1.8;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 3rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .feature-card {
            padding: 2.5rem;
            border-radius: 15px;
            background: #f7fafc;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            border-color: #667eea;
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.1);
        }

        .feature-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 1.5rem;
            color: #ffffff;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            color: #2d3748;
            margin-bottom: 1rem;
        }

        .feature-card p {
            color: #718096;
            line-height: 1.8;
        }

        /* CTA Section */
        .cta-section {
            padding: 8rem 5%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            text-align: center;
            color: #ffffff;
        }

        .cta-section h2 {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            margin-bottom: 1.5rem;
        }

        .cta-section p {
            font-size: 1.3rem;
            margin-bottom: 2.5rem;
            opacity: 0.95;
        }

        @media (max-width: 768px) {
            .brand-name {
                font-size: 2.5rem;
            }

            .brand-slogan {
                font-size: 1rem;
            }

            .hero-content {
                flex-direction: column;
                text-align: center;
                justify-content: center;
            }

            .hero-text h1 {
                font-size: 2.5rem;
            }

            .nav-links {
                display: none;
            }

            .cta-buttons {
                flex-direction: column;
            }

            .visual-card {
                transform: none;
            }
        }
    </style>
</head>
<body>
    <!-- Loader -->
    <div class="loader-container" id="loader">
        <div class="loader-content">
            <div class="brand-name">Expandify SA</div>
            <div class="brand-slogan">Uplifting small businesses uplifts the economy</div>
            <div class="dots-container">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
        </div>
    </div> <hr /> <hr /> <hr />

    <!-- Main Content -->
    <div class="main-content" id="mainContent">
        <!-- Hero Section -->
        <section class="hero-section">
            <nav class="navbar">
                <div class="logo">Expandify SA</div>
                <ul class="nav-links">
                    <li><a href="#features">Features</a></li>
                    <li><a href="#about">About</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </nav>

            <div class="hero-content">
                <div class="hero-text">
                    <h1>Empowering Small Businesses to Thrive</h1>
                    <p>We believe that uplifting small businesses uplifts the economy. Join us in transforming the landscape of entrepreneurship across South Africa.</p>
                    <div class="cta-buttons">
                        <a href="RegisterCustomer.aspx" class="btn btn-primary">Get Started</a>
                        <a href="#" class="btn btn-secondary">Learn More</a>
                    </div>
                </div>

                <div class="hero-visual">
                    <div class="visual-card">
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-number">500+</div>
                                <div class="stat-label">Businesses Supported</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">98%</div>
                                <div class="stat-label">Success Rate</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">R50M+</div>
                                <div class="stat-label">Revenue Generated</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">24/7</div>
                                <div class="stat-label">Support Available</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features-section" id="features">
            <div class="section-header">
                <h2>Why Choose Expandify SA?</h2>
                <p>We provide comprehensive solutions designed specifically for small businesses to grow and succeed in today's competitive market.</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">📊</div>
                    <h3>Business Analytics</h3>
                    <p>Get deep insights into your business performance with our advanced analytics dashboard and real-time reporting.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">💰</div>
                    <h3>Financial Management</h3>
                    <p>Streamline your finances with integrated tools for invoicing, expense tracking, and financial forecasting.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🚀</div>
                    <h3>Growth Strategies</h3>
                    <p>Access proven strategies and expert guidance to scale your business and reach new markets effectively.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🤝</div>
                    <h3>Community Network</h3>
                    <p>Connect with other entrepreneurs, share experiences, and build valuable partnerships within our ecosystem.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🎓</div>
                    <h3>Training & Resources</h3>
                    <p>Enhance your skills with our comprehensive training programs and resource library tailored for SMEs.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🔒</div>
                    <h3>Secure Platform</h3>
                    <p>Your data is protected with enterprise-grade security and compliance with South African regulations.</p>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <h2>Ready to Expand Your Business?</h2>
            <p>Join thousands of successful entrepreneurs who have transformed their businesses with Expandify SA</p>
            <a href="#" class="btn btn-primary">Start Your Journey Today</a>
        </section>
    </div>

    <script>
        // Loader functionality
        window.addEventListener('load', function () {
            setTimeout(function () {
                document.getElementById('loader').classList.add('hidden');
                document.getElementById('mainContent').classList.add('visible');
            }, 4500); // Show loader for 4.5 seconds (name 0s, slogan 2s, extra time 2.5s)
        });

        // Smooth scrolling for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>