<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterCustomer.aspx.cs" Inherits="HackathonSolutionFNB.RegisterCustomer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register - SideHustle SA</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 1rem;
        }

        .registration-container {
            max-width: 900px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .registration-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3rem 2rem;
            text-align: center;
            color: #ffffff;
        }

        .registration-header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 700;
        }

        .registration-header p {
            font-size: 1.1rem;
            opacity: 0.95;
        }

        .form-content {
            padding: 3rem 2rem;
        }

        .account-type-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .account-type-card {
            padding: 2rem 1.5rem;
            border: 3px solid #e2e8f0;
            border-radius: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f7fafc;
        }

        .account-type-card:hover {
            transform: translateY(-5px);
            border-color: #667eea;
        }

        .account-type-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.2);
        }

        .account-type-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .account-type-card h3 {
            font-size: 1.3rem;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .account-type-card p {
            font-size: 0.9rem;
            color: #718096;
            line-height: 1.6;
        }

        .form-section {
            margin-bottom: 2.5rem;
        }

        .section-title {
            font-size: 1.5rem;
            color: #2d3748;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
            font-weight: 600;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 0.95rem;
            color: #4a5568;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .required {
            color: #e53e3e;
            margin-left: 3px;
        }

        .form-control {
            padding: 0.9rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%234a5568' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            padding-right: 2.5rem;
        }

        .file-upload-container {
            display: flex;
            flex-direction: column;
        }

        .file-upload-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-upload-input {
            padding: 0.9rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            background: #ffffff;
            width: 100%;
            cursor: pointer;
        }

        .file-upload-button {
            position: absolute;
            right: 4px;
            top: 4px;
            bottom: 4px;
            padding: 0 1rem;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .file-upload-button:hover {
            background: #5a6fd8;
        }

        .file-upload-input:focus + .file-upload-button {
            outline: none;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.3);
        }

        .file-info {
            margin-top: 0.5rem;
            font-size: 0.85rem;
            color: #718096;
        }

        .skills-container {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-top: 1rem;
        }

        .skill-tag {
            padding: 0.5rem 1rem;
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s ease;
            user-select: none;
        }

        .skill-tag:hover {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.1);
        }

        .skill-tag.selected {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #ffffff;
            border-color: transparent;
        }

        .custom-skill-container {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
            align-items: center;
        }

        .custom-skill-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }

        .custom-skill-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .add-skill-btn {
            padding: 0.75rem 1.5rem;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .add-skill-btn:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem;
            background: #f7fafc;
            border-radius: 10px;
            margin-top: 1rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .checkbox-group label {
            margin: 0;
            cursor: pointer;
            font-size: 0.95rem;
        }

        .info-box {
            background: #ebf8ff;
            border-left: 4px solid #4299e1;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }

        .info-box p {
            color: #2c5282;
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .btn-submit {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #ffffff;
            border: none;
            border-radius: 12px;
            font-size: 1.2rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            margin-top: 2rem;
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
        }

        .btn-submit:active {
            transform: translateY(-1px);
        }

        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #718096;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .provider-fields,
        .seeker-fields {
            display: none;
        }

        .provider-fields.active,
        .seeker-fields.active {
            display: block;
        }

        /* Social Login Styles */
        .social-login {
            margin: 2rem 0;
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
            color: #718096;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }

        .divider span {
            padding: 0 1rem;
            font-size: 0.9rem;
        }

        .social-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .btn-social {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            padding: 0.9rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #ffffff;
            color: #4a5568;
        }

        .btn-social:hover {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.05);
        }

        .btn-social img {
            width: 20px;
            height: 20px;
        }

        .btn-google {
            color: #4a5568;
        }

        .btn-facebook {
            color: #1877F2;
        }

        @media (max-width: 768px) {
            .registration-header h1 {
                font-size: 2rem;
            }

            .form-content {
                padding: 2rem 1.5rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .account-type-selector {
                grid-template-columns: 1fr;
            }
            
            .social-buttons {
                grid-template-columns: 1fr;
            }
            
            .custom-skill-container {
                flex-direction: column;
                align-items: stretch;
            }
            
            .add-skill-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="registration-container">
            <div class="registration-header">
                <h1>Join SideHustle SA</h1>
                <p>Start your journey to financial growth and opportunity</p>
            </div>

            <div class="form-content">
                <!-- Social Login Options -->
                <div class="social-login">
                    <div class="social-buttons">
                        <button type="button" class="btn-social btn-google">
                            <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google" />
                            Continue with Google
                        </button>
                        <button type="button" class="btn-social btn-facebook">
                            <img src="https://static.xx.fbcdn.net/rsrc.php/v3/yR/r/tInzwsw2pVX.png" alt="Facebook" />
                            Continue with Facebook
                        </button>
                    </div>
                    <div class="divider">
                        <span>or register with email</span>
                    </div>
                </div>

                <!-- Account Type Selection -->
                <div class="form-section">
                    <div class="section-title">I want to...</div>
                    <div class="account-type-selector">
                        <div class="account-type-card" id="providerCard" onclick="selectAccountType('provider')">
                            <div class="account-type-icon">💼</div>
                            <h3>Offer Services</h3>
                            <p>I want to provide services and find clients</p>
                            <asp:HiddenField ID="hdnAccountType" runat="server" />
                        </div>
                        <div class="account-type-card" id="seekerCard" onclick="selectAccountType('seeker')">
                            <div class="account-type-icon">🔍</div>
                            <h3>Find Workers</h3>
                            <p>I need to hire someone for a task or service</p>
                        </div>
                    </div>
                </div>

                <!-- Personal Information -->
                <div class="form-section">
                    <div class="section-title">Personal Information</div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>First Name <span class="required">*</span></label>
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter your first name" required="required"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Last Name <span class="required">*</span></label>
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter your last name" required="required"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>ID Number <span class="required">*</span></label>
                            <asp:TextBox ID="txtIDNumber" runat="server" CssClass="form-control" placeholder="Enter your SA ID number" MaxLength="13" required="required"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>ID Document (PDF) <span class="required">*</span></label>
                            <div class="file-upload-wrapper">
                                <asp:FileUpload ID="fileIDDocument" runat="server" CssClass="file-upload-input" accept=".pdf" />
                                <button type="button" class="file-upload-button" onclick="document.getElementById('<%= fileIDDocument.ClientID %>').click()">Browse</button>
                            </div>
                            <div class="file-info">Upload a PDF copy of your ID document (max 5MB)</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Mobile Number <span class="required">*</span></label>
                            <asp:TextBox ID="txtMobileNumber" runat="server" CssClass="form-control" placeholder="e.g., 0821234567" TextMode="Phone" required="required"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Email Address <span class="required">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="your.email@example.com" TextMode="Email" required="required"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- Location Information -->
                <div class="form-section">
                    <div class="section-title">Location Details</div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Province <span class="required">*</span></label>
                            <asp:DropDownList ID="ddlProvince" runat="server" CssClass="form-control" required="required">
                                <asp:ListItem Value="">Select Province</asp:ListItem>
                                <asp:ListItem Value="EC">Eastern Cape</asp:ListItem>
                                <asp:ListItem Value="FS">Free State</asp:ListItem>
                                <asp:ListItem Value="GP">Gauteng</asp:ListItem>
                                <asp:ListItem Value="KZN">KwaZulu-Natal</asp:ListItem>
                                <asp:ListItem Value="LP">Limpopo</asp:ListItem>
                                <asp:ListItem Value="MP">Mpumalanga</asp:ListItem>
                                <asp:ListItem Value="NC">Northern Cape</asp:ListItem>
                                <asp:ListItem Value="NW">North West</asp:ListItem>
                                <asp:ListItem Value="WC">Western Cape</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>City/Town <span class="required">*</span></label>
                            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="Enter your city or town" required="required"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Suburb/Area <span class="required">*</span></label>
                        <asp:TextBox ID="txtSuburb" runat="server" CssClass="form-control" placeholder="Enter your suburb or area" required="required"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Street Address</label>
                        <asp:TextBox ID="txtStreetAddress" runat="server" CssClass="form-control" placeholder="Enter your street address (optional)"></asp:TextBox>
                    </div>
                </div>

                <!-- Service Provider Specific Fields -->
                <div class="provider-fields" id="providerFields">
                    <div class="form-section">
                        <div class="section-title">Service Provider Details</div>
                        
                        <div class="info-box">
                            <p><strong>💡 Build your profile:</strong> Select your skills to start connecting with clients who need your services.</p>
                        </div>

                        <div class="form-group">
                            <label>Skills & Services <span class="required">*</span></label>
                            <p style="color: #718096; font-size: 0.9rem; margin-bottom: 0.75rem;">Select all skills you can offer (minimum 1 required)</p>
                            <div class="skills-container">
                                <div class="skill-tag" onclick="toggleSkill(this, 'Gardening')">🌱 Gardening</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Cleaning')">🧹 Cleaning</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Painting')">🎨 Painting</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Delivery')">🚚 Delivery</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Tutoring')">📚 Tutoring</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Hairdressing')">💇 Hairdressing</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Repairs')">🔧 Repairs</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Plumbing')">🚰 Plumbing</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Electrical')">⚡ Electrical</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Carpentry')">🪚 Carpentry</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Cooking')">👨‍🍳 Cooking</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Photography')">📷 Photography</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Event Help')">🎉 Event Help</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Pet Care')">🐕 Pet Care</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Childcare')">👶 Childcare</div>
                                <div class="skill-tag" onclick="toggleSkill(this, 'Admin Work')">📝 Admin Work</div>
                            </div>
                            <asp:HiddenField ID="hdnSelectedSkills" runat="server" />
                            
                            <!-- Custom Skill Input -->
                            <div class="custom-skill-container">
                                <input type="text" id="customSkillInput" class="custom-skill-input" placeholder="Type a skill not listed above" />
                                <button type="button" class="add-skill-btn" onclick="addCustomSkill()">Add Skill</button>
                            </div>
                        </div>

                        <div class="checkbox-group">
                            <asp:CheckBox ID="chkHasTransport" runat="server" />
                            <label for="<%= chkHasTransport.ClientID %>">I have my own transport</label>
                        </div>

                        <div class="checkbox-group">
                            <asp:CheckBox ID="chkHasTools" runat="server" />
                            <label for="<%= chkHasTools.ClientID %>">I have my own tools/equipment</label>
                        </div>
                    </div>
                </div>

                <!-- Job Seeker Specific Fields -->
                <div class="seeker-fields" id="seekerFields">
                    <div class="form-section">
                        <div class="section-title">Account Details</div>
                        
                        <div class="info-box">
                            <p><strong>💡 About hiring:</strong> As a client, you'll be able to post jobs, browse service providers, and securely pay for completed work through the app.</p>
                        </div>

                        <div class="form-group">
                            <label>Account Type</label>
                            <asp:DropDownList ID="ddlSeekerType" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Select Type</asp:ListItem>
                                <asp:ListItem Value="Individual">Individual/Homeowner</asp:ListItem>
                                <asp:ListItem Value="Business">Small Business</asp:ListItem>
                                <asp:ListItem Value="Organization">Organization/NGO</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label>Business/Organization Name (if applicable)</label>
                            <asp:TextBox ID="txtBusinessName" runat="server" CssClass="form-control" placeholder="Enter business or organization name"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- Account Security -->
                <div class="form-section">
                    <div class="section-title">Account Security</div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Password <span class="required">*</span></label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Create a strong password" required="required"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Confirm Password <span class="required">*</span></label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter your password" required="required"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- Terms and Conditions -->
                <div class="checkbox-group">
                    <asp:CheckBox ID="chkTerms" runat="server" required="required" />
                    <label for="<%= chkTerms.ClientID %>">I agree to the <a href="#" style="color: #667eea;">Terms & Conditions</a> and <a href="#" style="color: #667eea;">Privacy Policy</a> <span class="required">*</span></label>
                </div>

                <div class="checkbox-group">
                    <asp:CheckBox ID="chkMarketing" runat="server" />
                    <label for="<%= chkMarketing.ClientID %>">I want to receive updates about job opportunities and platform features</label>
                </div>

                <!-- Submit Button -->
                <asp:Button ID="Button1" runat="server" Text="Create New Account" CssClass="btn-submit" />

                <div class="login-link">
                    Already have an account? <a href="Login.aspx">Sign In</a>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        var selectedSkills = [];

        function selectAccountType(type) {
            // Update hidden field
            document.getElementById('<%= hdnAccountType.ClientID %>').value = type;

            // Update UI
            document.getElementById('providerCard').classList.remove('selected');
            document.getElementById('seekerCard').classList.remove('selected');
            document.getElementById('providerFields').classList.remove('active');
            document.getElementById('seekerFields').classList.remove('active');

            if (type === 'provider') {
                document.getElementById('providerCard').classList.add('selected');
                document.getElementById('providerFields').classList.add('active');
            } else {
                document.getElementById('seekerCard').classList.add('selected');
                document.getElementById('seekerFields').classList.add('active');
            }
        }

        function toggleSkill(element, skillName) {
            element.classList.toggle('selected');

            var index = selectedSkills.indexOf(skillName);
            if (index > -1) {
                selectedSkills.splice(index, 1);
            } else {
                selectedSkills.push(skillName);
            }

            // Update hidden field with comma-separated skills
            document.getElementById('<%= hdnSelectedSkills.ClientID %>').value = selectedSkills.join(',');
        }

        function addCustomSkill() {
            var customSkillInput = document.getElementById('customSkillInput');
            var skillName = customSkillInput.value.trim();
            
            if (skillName === '') {
                alert('Please enter a skill name');
                return;
            }
            
            // Check if skill already exists
            if (selectedSkills.indexOf(skillName) !== -1) {
                alert('This skill has already been added');
                customSkillInput.value = '';
                return;
            }
            
            // Create a new skill tag
            var skillsContainer = document.querySelector('.skills-container');
            var newSkillTag = document.createElement('div');
            newSkillTag.className = 'skill-tag selected';
            newSkillTag.textContent = skillName;
            newSkillTag.onclick = function() { toggleSkill(this, skillName); };
            
            // Add to container
            skillsContainer.appendChild(newSkillTag);
            
            // Add to selected skills
            selectedSkills.push(skillName);
            document.getElementById('<%= hdnSelectedSkills.ClientID %>').value = selectedSkills.join(',');
            
            // Clear input
            customSkillInput.value = '';
        }

        // Allow pressing Enter to add custom skill
        document.getElementById('customSkillInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                addCustomSkill();
            }
        });

        // Social login buttons functionality
        document.querySelector('.btn-google').addEventListener('click', function() {
            // Implement Google OAuth integration here
            alert('Google login functionality would be implemented here');
        });

        document.querySelector('.btn-facebook').addEventListener('click', function() {
            // Implement Facebook OAuth integration here
            alert('Facebook login functionality would be implemented here');
        });

        // File upload display functionality
        document.getElementById('<%= fileIDDocument.ClientID %>').addEventListener('change', function(e) {
            var fileName = e.target.files[0] ? e.target.files[0].name : 'No file chosen';
            var fileInfo = document.querySelector('.file-info');
            fileInfo.textContent = 'Selected: ' + fileName + ' (max 5MB)';
            
            // Check file size (client-side validation)
            if (e.target.files[0] && e.target.files[0].size > 5 * 1024 * 1024) {
                alert('File size exceeds 5MB limit. Please choose a smaller file.');
                e.target.value = '';
                fileInfo.textContent = 'Upload a PDF copy of your ID document (max 5MB)';
            }
            
            // Check file type
            if (e.target.files[0] && e.target.files[0].type !== 'application/pdf') {
                alert('Please select a PDF file only.');
                e.target.value = '';
                fileInfo.textContent = 'Upload a PDF copy of your ID document (max 5MB)';
            }
        });

        // Form validation
        document.getElementById('form1').addEventListener('submit', function(e) {
            var accountType = document.getElementById('<%= hdnAccountType.ClientID %>').value;
            
            if (!accountType) {
                e.preventDefault();
                alert('Please select whether you want to offer services or find workers.');
                return false;
            }

            if (accountType === 'provider' && selectedSkills.length === 0) {
                e.preventDefault();
                alert('Please select at least one skill you can offer.');
                return false;
            }

            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            var confirmPassword = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please try again.');
                return false;
            }

            if (password.length < 8) {
                e.preventDefault();
                alert('Password must be at least 8 characters long.');
                return false;
            }

            var terms = document.getElementById('<%= chkTerms.ClientID %>');
            if (!terms.checked) {
                e.preventDefault();
                alert('Please accept the Terms & Conditions to continue.');
                return false;
            }

            // Check if ID document is uploaded
            var fileUpload = document.getElementById('<%= fileIDDocument.ClientID %>');
            if (!fileUpload.value) {
                e.preventDefault();
                alert('Please upload a PDF copy of your ID document.');
                return false;
            }
        });
    </script>
</body>
</html>