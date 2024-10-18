# PhotoPostLocal

## Descripción
PhotoPostLocal es una aplicación compuesta por un `backend` desarrollado en Node.js con Express y un `frontend` desarrollado en Flutter.

## Estructura del Proyecto
- `backend/`: Contiene la API RESTful construida con Node.js y Express, utilizando MySQL como base de datos.
- `frontend/`: Aplicación móvil construida con Flutter, diseñada para interactuar con la API del backend.

---

## Requisitos Previos
Antes de empezar, asegúrate de tener instalados:

- **Node.js** (versión 18 o superior) en sur forma LTS
- **Flutter** (versión 3.0 o superior)
- **Android Studio** (para usar el AVD Manager y emular dispositivos Android)
- **MySQL** (para la base de datos del backend)

---

## Instrucciones de Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/EndlessGG/PhotoPost.git
cd PhotoPost
```

### 2. BackEnd

Instalacion de dependencias dentro de backend
```bash
npm install
```

Configuracion de variables de entorno
```bash
copy .env.example .env
```

Modo de Produccion:

- Modo de Desarrollo: para reinicar automaticamente el servidor cada que se haga cambios
```bash
npm run dev
```

- Modo de Produccion: para ejecutar sin reinicio automatico
```bash
npm start
```

### 3. Front End

Instalacion de dependencias dentro de frotnend
```bash
flutter pub get
```

Configuracion de conexion con el BackEnd
pendiente..

Ejecucion de Aplicacion
 - Abrir la Externsion de AVD Manager e iniciar emulador
 - Ejecucion de Aplicacion en el Emulador
 ```bash
 flutter run
 ```
