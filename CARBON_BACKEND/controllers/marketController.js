const { v4: uuidv4 } = require('uuid');

// --- MOCK DATABASE (In real life, this is PostgreSQL) ---
// ... existing imports and data ...

// ADD THIS: Mock Transaction Database
let transactions = [
    // Sample initial data
    { 
        id: 'tx_101', 
        user_id: 'u1', 
        type: 'BUY', 
        amount_tons: 10, 
        price_total: 8000, 
        seller_name: 'Green Solar Ltd', 
        date: new Date().toISOString() 
    }
];

// ... existing getNearbySellers ...

// UPDATE THIS: buyCredits function
exports.buyCredits = (req, res) => {
    const { buyer_id, listing_id, quantity } = req.body;

    const listing = listings.find(l => l.id === listing_id);
    const buyer = users.find(u => u.id === buyer_id);

    // ... (Keep existing validation checks) ...

    // EXECUTE TRADE
    buyer.balance_fiat -= (listing.price * quantity);
    buyer.balance_carbon += quantity;
    listing.available -= quantity;

    // --- NEW CODE: Record Transaction ---
    const newTx = {
        id: uuidv4(),
        user_id: buyer_id,
        type: 'BUY',
        amount_tons: quantity,
        price_total: listing.price * quantity,
        seller_name: listing.seller_name,
        date: new Date().toISOString()
    };
    transactions.push(newTx);
    // ------------------------------------

    res.json({
        success: true,
        message: "Trade Successful!",
        certificate: newTx, // Send back the proof
    });
};

// ADD THIS NEW FUNCTION: Get History
exports.getUserHistory = (req, res) => {
    const { user_id } = req.query;
    
    // Filter transactions for this user
    const userTx = transactions.filter(t => t.user_id === user_id);
    
    // Sort by newest first
    userTx.sort((a, b) => new Date(b.date) - new Date(a.date));
    
    res.json({ success: true, data: userTx });
};

// ... existing uploadAsset and helper functions ...

let users = [
    { id: 'u1', name: 'You', balance_fiat: 50000, balance_carbon: 0, kyc_status: 'VERIFIED' }
];

let listings = [
  {
    id: "L1",
    seller_name: "Green Solar Ltd",
    type: "Solar",
    price: 800,
    available: 500,
    lat: 22.3039,
    lng: 70.8022, // Rajkot
    verified: true
  },
  {
    id: "L2",
    seller_name: "Forest Carbon Trust",
    type: "Forestry",
    price: 1200,
    available: 200,
    lat: 22.2900,
    lng: 70.7800, // Nearby Rajkot
    verified: true
  },
  {
    id: "L3",
    seller_name: "Biogas Energy Plant",
    type: "Biogas",
    price: 650,
    available: 1000,
    lat: 22.4500,
    lng: 70.9000, // Within 50km
    verified: true
  }
];


// --- LOGIC ---

// 1. Get Sellers Nearby (The Radius Logic)
exports.getNearbySellers = (req, res) => {
    const { lat, long, radiusKm } = req.query; 
    const userLat = parseFloat(lat);
    const userLong = parseFloat(long);
    const searchRadius = parseFloat(radiusKm) || 50; // Default 50km

    // Simple Haversine Distance Calculation
    const nearby = listings.filter(item => {
        const dist = calculateDistance(userLat, userLong, item.lat, item.long);
        item.distance_km = dist.toFixed(1); // Add distance info to result
        return dist <= searchRadius;
    });

    res.json({ success: true, count: nearby.length, data: nearby });
};

// 2. Buy Credits (The Transaction)
exports.buyCredits = (req, res) => {
    const { buyer_id, listing_id, quantity } = req.body;

    const listing = listings.find(l => l.id === listing_id);
    const buyer = users.find(u => u.id === buyer_id);

    // VALIDATION CHECKS
    if (!listing) return res.status(404).json({ error: "Listing not found" });
    if (listing.available < quantity) return res.status(400).json({ error: "Not enough stock available" });

    const totalCost = listing.price * quantity;

    if (buyer.balance_fiat < totalCost) {
        return res.status(400).json({ error: "Insufficient Funds in Fiat Wallet" });
    }

    // EXECUTE TRADE
    // 1. Deduct Money
    buyer.balance_fiat -= totalCost;
    // 2. Add Carbon
    buyer.balance_carbon += quantity;
    // 3. Reduce Stock
    listing.available -= quantity;

    // 4. Generate Certificate Record
    const certificate = {
        cert_id: uuidv4(),
        owner: buyer.name,
        tons: quantity,
        source: listing.seller_name,
        date: new Date().toISOString()
    };

    res.json({
        success: true,
        message: "Trade Successful!",
        certificate: certificate,
        new_balance: buyer.balance_fiat
    });
};

// 3. Upload Credit (Seller)
exports.uploadAsset = (req, res) => {
    // File is handled by route middleware
    if (!req.file) return res.status(400).json({ error: "Certificate file is required" });

    const newListing = {
        id: uuidv4(),
        seller_name: req.body.seller_name || "Unknown Seller",
        type: req.body.type,
        price: parseFloat(req.body.price),
        available: parseInt(req.body.tonnage),
        verified: false, // Default to pending
        doc_url: req.file.path
    };

    listings.push(newListing);

    res.json({ success: true, message: "Asset submitted for verification", id: newListing.id });
};

// Helper: Haversine Formula (Distance between coords)
function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of earth in km
    const dLat = deg2rad(lat2 - lat1);
    const dLon = deg2rad(lon2 - lon1);
    const a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2); 
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    return R * c; // Distance in km
}

function deg2rad(deg) {
    return deg * (Math.PI/180);
}


