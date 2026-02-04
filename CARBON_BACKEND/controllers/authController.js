// MOCK DATABASE for Users
// In a real app, this would be a PostgreSQL or MongoDB query
let users = [
    // Pre-registered user for testing
    { 
        id: 'u1', 
        phone: '9876543210', 
        otp: null, 
        pin: '1234', 
        name: 'Demo Trader',
        balance_fiat: 50000 
    }
];

const { v4: uuidv4 } = require('uuid');

// 1. Send OTP (Step 1)
exports.sendOtp = (req, res) => {
    const { phone } = req.body;
    
    if (!phone) {
        return res.status(400).json({ error: "Phone number is required" });
    }

    // In a real app, integrate Twilio/Fast2SMS here.
    // For Prototype: We just pretend to send it.
    const mockOtp = "1234"; 
    
    // Check if user exists or create temp record
    let user = users.find(u => u.phone === phone);
    if (!user) {
        // Create temporary user holder
        user = { id: uuidv4(), phone, otp: mockOtp, isNew: true };
        users.push(user);
    } else {
        user.otp = mockOtp; // Update existing user OTP
    }

    console.log(`[Mock SMS] OTP for ${phone} is ${mockOtp}`);
    
    res.json({ success: true, message: "OTP sent successfully" });
};

// 2. Verify OTP (Step 2)
exports.verifyOtp = (req, res) => {
    const { phone, otp } = req.body;

    const user = users.find(u => u.phone === phone);

    if (!user) {
        return res.status(404).json({ error: "User not found. Request OTP first." });
    }

    // Hardcoded '1234' for easy testing
    if (otp === "1234" || user.otp === otp) {
        res.json({ 
            success: true, 
            message: "OTP Verified", 
            user_id: user.id,
            isNewUser: user.isNew || false
        });
    } else {
        res.status(400).json({ error: "Invalid OTP" });
    }
};

// 3. Set/Verify PIN (Step 3 - Final Login)
exports.loginWithPin = (req, res) => {
    const { user_id, pin } = req.body;
    
    const user = users.find(u => u.id === user_id);
    
    if (!user) return res.status(404).json({ error: "User not found" });

    // If user is setting a PIN for the first time
    if (user.isNew) {
        user.pin = pin;
        user.isNew = false; // Registration complete
        user.balance_fiat = 10000; // Give signup bonus
        return res.json({ success: true, message: "PIN Set Successfully. Login Complete!", user });
    }

    // Normal Login
    if (user.pin === pin) {
        return res.json({ success: true, message: "Login Successful", user });
    } else {
        return res.status(401).json({ error: "Incorrect PIN" });
    }
};