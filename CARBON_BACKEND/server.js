// server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/authRoutes');
const marketRoutes = require('./routes/marketRoutes');

const app = express();
const PORT = 3000;

// Middleware
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  res.header(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, OPTIONS"
  );
  if (req.method === "OPTIONS") {
    return res.sendStatus(200);
  }
  next();
}); // Allow Flutter app to connect

app.use(bodyParser.json());
app.use(express.static('uploads')); // Make uploaded files accessible

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/market', marketRoutes);

// Health Check
app.get('/', (req, res) => {
    res.send("Carbon Wallet API is Running...");
});

// Start Server
app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on http://0.0.0.0:3000");
});
