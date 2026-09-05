#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cat > /var/www/html/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>3-Tier App</title>
  <style>
    body { font-family: Arial; margin: 50px; }
    .container { max-width: 500px; margin: 0 auto; padding: 20px; 
                 border: 1px solid #ccc; border-radius: 5px; }
    input { width: 100%; padding: 10px; margin: 10px 0; }
    button { width: 100%; padding: 10px; background: blue; color: white; border: none; }
  </style>
</head>
<body>
  <div class="container">
    <h1>3-Tier Application</h1>
    <form action="http://${app_alb_dns}:3000/submit" method="POST">
      <input type="text" name="username" placeholder="Username" required>
      <input type="email" name="email" placeholder="Email" required>
      <button type="submit">Submit</button>
    </form>
  </div>
</body>
</html>
HTML