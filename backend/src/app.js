const express = require('express')
const routes = require('./routes/route')

const app = express()

app.use(express.json())

// uso de rutas (api)
app.use('/api', routes)

module.exports = app
