const statusController = require('../controllers/statusController')
const express = require('express')

const router = express.Router()

// Ruta de Status: Verificacion de estado del servidor
router.get('/status-server', statusController.getStatus)
// mass rutas...

module.exports = router
