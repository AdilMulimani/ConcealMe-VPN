export const VERIFICATION_EMAIL_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verify Your Email</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
      text-align: center;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .header {
      background: linear-gradient(to right, #005ff7, #3ba4f8);
      color: white;
      padding: 25px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
    }
    .content {
      padding: 30px;
      color: #333;
      text-align: left;
      line-height: 1.6;
    }
    .code-box {
      background: #005ff7;
      color: white;
      font-size: 38px;
      font-weight: bold;
      letter-spacing: 6px;
      padding: 20px 35px;
      display: inline-block;
      border-radius: 8px;
      margin: 25px 0;
      box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
      text-transform: uppercase;
    }
    .footer {
      font-size: 12px;
      color: #777;
      padding: 15px;
      text-align: center;
      background: #f9f9f9;
      border-bottom-left-radius: 10px;
      border-bottom-right-radius: 10px;
    }
    .footer p {
      margin: 5px 0;
    }
    @media (max-width: 600px) {
      .content {
        padding: 20px;
      }
      .code-box {
        font-size: 32px;
        padding: 15px 25px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      Verify Your Email
    </div>
    <div class="content">
      <p>Hello,</p>
      <p>Thank you for signing up! Your verification code is:</p>
      <div style="text-align: center;">
        <div class="code-box">{verificationCode}</div>
      </div>
      <p style="text-align: center;">Enter this code on the verification page to complete your registration.</p>
      <p style="text-align: center; color: #777;">This code will expire in 15 minutes for security reasons.</p>
      <p>If you didn't create an account with us, please ignore this email.</p>
      <p style="margin-top: 25px;">Best regards, <br><strong>Your VPN Guide</strong></p>
    </div>
    <div class="footer">
      <p>This is an automated message. Please do not reply to this email.</p>
      <p>&copy; ${new Date().getFullYear()} ObscureMe VPN App</p>
    </div>
  </div>
</body>
</html>
`;

export const RESET_PASSWORD_REQUEST_EMAIL_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Your Password</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
      text-align: center;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .header {
      background: linear-gradient(to right, #005ff7, #1e8fff);
      color: white;
      padding: 20px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
    }
    .content {
      padding: 25px;
      color: #333;
      text-align: left;
    }
    .token-box {
      background: #005ff7;
      color: white;
      font-size: 36px;
      font-weight: bold;
      letter-spacing: 6px;
      padding: 15px 30px;
      display: inline-block;
      border-radius: 5px;
      margin: 20px 0;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }
    .footer {
      font-size: 12px;
      color: #777;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      Password Reset Request
    </div>
    <div class="content">
      <p>Hello,</p>
      <p>We received a request to reset your password. If you didn't make this request, please ignore this email.</p>
      <div style="text-align: center;">
        <div class="token-box">{resetPasswordToken}</div>
      </div>
      <p style="text-align: center;">Enter this code on the verification page to reset your password.</p>
      <p style="text-align: center; color: #777;">This code will expire in 1 hour for security reasons.</p>
      <p style="margin-top: 20px;">Best regards, <br><strong>Your VPN Guide</strong></p>
    </div>
    <div class="footer">
      <p>This is an automated message. Please do not reply to this email.</p>
    </div>
  </div>
</body>
</html>
`;

export const PASSWORD_RESET_SUCCESS_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Password Reset Successful</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
      text-align: center;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .header {
      background: linear-gradient(to right, #005ff7, #1e8fff);
      color: white;
      padding: 20px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
    }
    .content {
      padding: 25px;
      color: #333;
      text-align: left;
    }
    .success-icon {
      background-color: #005ff7;
      color: white;
      width: 60px;
      height: 60px;
      line-height: 60px;
      border-radius: 50%;
      display: inline-block;
      font-size: 32px;
      font-weight: bold;
      margin: 20px 0;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }
    .security-tips {
      background-color: #f8f9fa;
      padding: 15px;
      border-left: 4px solid #005ff7;
      margin-top: 20px;
      border-radius: 5px;
    }
    .footer {
      font-size: 12px;
      color: #777;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      Password Reset Successful
    </div>
    <div class="content">
      <p>Hello,</p>
      <p>We're writing to confirm that your password has been successfully reset.</p>
      <div style="text-align: center;">
        <div class="success-icon">✓</div>
      </div>
      <p>If you did not initiate this password reset, please contact our support team immediately.</p>
      <div class="security-tips">
        <p><strong>For security reasons, we recommend that you:</strong></p>
        <ul>
          <li>Use a strong, unique password.</li>
          <li>Enable two-factor authentication if available.</li>
          <li>Avoid using the same password across multiple sites.</li>
        </ul>
      </div>
      <p style="margin-top: 20px;">Best regards, <br><strong>Your VPN Guide</strong></p>
    </div>
    <div class="footer">
      <p>This is an automated message. Please do not reply to this email.</p>
    </div>
  </div>
</body>
</html>
`;

export const VERIFICATION_EMAIL_SUCCESS_TEMPLATE = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Welcome to ObscureMe VPN</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
      text-align: center;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .header {
      background: linear-gradient(to right, #005ff7, #3ba4f8);
      color: white;
      padding: 25px;
      text-align: center;
      font-size: 24px;
      font-weight: bold;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
    }
    .content {
      padding: 30px;
      color: #333;
      text-align: left;
      line-height: 1.6;
    }
    .welcome-box {
      background: #005ff7;
      color: white;
      font-size: 22px;
      font-weight: bold;
      padding: 15px 25px;
      display: inline-block;
      border-radius: 8px;
      margin: 20px 0;
      box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
    }
    .btn {
      display: inline-block;
      background: #005ff7;
      color: white;
      text-decoration: none;
      font-size: 18px;
      font-weight: bold;
      padding: 12px 25px;
      border-radius: 8px;
      margin-top: 20px;
      box-shadow: 0 3px 6px rgba(0, 0, 0, 0.2);
    }
    .footer {
      font-size: 12px;
      color: #777;
      padding: 15px;
      text-align: center;
      background: #f9f9f9;
      border-bottom-left-radius: 10px;
      border-bottom-right-radius: 10px;
    }
    .footer p {
      margin: 5px 0;
    }
    @media (max-width: 600px) {
      .content {
        padding: 20px;
      }
      .welcome-box {
        font-size: 18px;
        padding: 12px 20px;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      Welcome to ObscureMe VPN!
    </div>
    <div class="content">
      <p>Hello <strong>{{user_name}}</strong>,</p>
      <p>We're excited to have you on board! You are now part of a secure and unrestricted internet experience.</p>
      <div style="text-align: center;">
        <div class="welcome-box">Your Online Privacy Starts Now</div>
      </div>
      <p>With ObscureMe VPN, you can:</p>
      <ul style="text-align: left; padding-left: 20px;">
        <li>✅ Browse securely and anonymously</li>
        <li>✅ Protect your personal data with encryption</li>
        <li>✅ Access restricted content without limits</li>
        <li>✅ Enjoy fast and reliable VPN connections</li>
      </ul>
      <p style="margin-top: 25px;">Best regards, <br><strong>ObscureMe VPN Team</strong></p>
    </div>
    <div class="footer">
      <p>This is an automated message. Please do not reply to this email.</p>
      <p>&copy; ${new Date().getFullYear()} ObscureMe VPN App</p>
    </div>
  </div>
</body>
</html>
`;

