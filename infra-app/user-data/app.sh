#!/bin/bash
curl -sL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs git

mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

cat > package.json << 'JSON'
{
  "name": "app-tier",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.17.1",
    "pg": "^8.7.1",
    "cors": "^2.8.5"
  }
}
JSON

cat > server.js << 'JS'
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const pool = new Pool({
  host: '${db_endpoint}',
  user: '${db_username}',
  password: '${db_password}',
  database: '${db_name}',
  port: 5432,
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.post('/submit', async (req, res) => {
  const { username, email } = req.body;
  try {
    await pool.query('INSERT INTO users (username, email) VALUES ($1, $2)', [username, email]);
    res.status(200).json({ message: 'User registered successfully!', data: { username, email } });
  } catch (err) {
    res.status(500).json({ error: 'Database error' });
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`App tier listening on port ${port}`);
});
JS

npm install
nohup node server.js > app.log 2>&1 &