const express = require('express');
const router = express.Router();
const marketController = require('../controllers/marketController.js');
const multer = require('multer');

// Configure File Upload (Multer)
const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, 'uploads/'),
    filename: (req, file, cb) => cb(null, Date.now() + '-' + file.originalname)
});
const upload = multer({ storage: storage });

// Define URLs
router.get('/nearby', marketController.getNearbySellers);
router.post('/buy', marketController.buyCredits);
router.post('/sell', upload.single('certificate'), marketController.uploadAsset);
router.get('/history', marketController.getUserHistory);

module.exports = router;