const db = require('../config/db')

const getAllUsers = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM users')
        res.json(rows)
    } catch (error) {
        res.status(500).json({ message: 'Error fetching users' })
    }
};

module.exports = { getAllUsers }
