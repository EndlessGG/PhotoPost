const app = require('./app')

const PORT = process.env.PORT || 3000

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`) // http://localhost:3000 -> para la conexion con el frontend :3
})

// Para correr en modo Produccion: npm start
// Para correr en modo desarrollador: npm run dev (para reiniciar de manera automatica el server en cada cambio)
