const getStatus = (req, res) => {
    res.json({ message: 'Servidor funcionando :D' })
}

module.exports = { getStatus }
