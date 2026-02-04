const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Route: POST /api/auth/send-otp
router.post('/send-otp', authController.sendOtp);

// Route: POST /api/auth/verify-otp
router.post('/verify-otp', authController.verifyOtp);

// Route: POST /api/auth/login-pin
router.post('/login-pin', authController.loginWithPin);

module.exports = router;