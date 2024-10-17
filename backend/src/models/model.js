const db = require('../config/db')

const createUser = async (userData) => {
    const { name, email } = userData
    const [result] = await db.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email])
    return result.insertId
}

module.exports = { createUser }
