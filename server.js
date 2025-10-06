// server.js
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

const app = express();
app.use(express.json());

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error("MongoDB connection error:", err));

// Define schema
const bookingSchema = new mongoose.Schema({
  name: String,
  carModel: String,
  pickupDate: Date,
  dropoffDate: Date,
});

const Booking = mongoose.model('Booking', bookingSchema);

// Routes
app.post('/bookings', async (req, res) => {
  try {
    const booking = new Booking(req.body);
    await booking.save();
    res.status(201).json(booking);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

app.get('/bookings', async (req, res) => {
  const bookings = await Booking.find();
  res.json(bookings);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

app.get('/', (req, res) => {
  res.send('Car Booking API is running on the 🚗.....');
});

