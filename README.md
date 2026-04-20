# 📱 Clínica Jesús - App iOS

Aplicación móvil desarrollada en **Swift (UIKit)** siguiendo el patrón **MVVM + Clean Architecture**, que permite gestionar información médica como especialidades, usuarios y navegación de perfiles, utilizando **Supabase** como backend (BaaS).

---

## 🚀 Características

* 🔐 Autenticación de usuarios (login)
* 👤 Gestión de perfiles
* 🩺 Listado de especialidades médicas
* 🔄 Consumo de API REST desde Supabase
* 🧠 Arquitectura escalable (MVVM + Clean Architecture)
* 📱 Interfaz construida programáticamente (UIKit)

---

## 🏗️ Arquitectura

El proyecto sigue una estructura basada en **Clean Architecture**, separando responsabilidades en capas:

```text
Presentation (UI)
│
├── ViewControllers
├── ViewModels
│
Domain
│
├── UseCases
├── Entities
│
Data
│
├── Repositories
├── DTOs
├── API / Network
```

### 🔄 Flujo de datos

```text
ViewController → ViewModel → UseCase → Repository → Supabase API
```

---

## 🧰 Tecnologías utilizadas

* **Swift + UIKit**
* **MVVM**
* **Clean Architecture**
* **Supabase (Auth + Database + API)**
* **URLSession (Networking)**
* **DTOs para mapeo de datos**
* **Programmatic UI (sin Storyboards)**

---

## 🔌 Backend - Supabase

Este proyecto utiliza **Supabase** como backend, lo que permite:

* Autenticación de usuarios
* Base de datos PostgreSQL
* API REST automática
* Manejo de tablas como:

  * `especialidades`
  * `usuarios`
  * `perfiles`

---

## ⚙️ Configuración del proyecto

1. Clonar el repositorio:

```bash
https://github.com/EDU11QR/ClinicaJesus-iOS.git
```

2. Abrir el proyecto en **Xcode**

3. Configurar tus credenciales de Supabase:

```swift
let supabaseURL = "https://TU-PROYECTO.supabase.co"
let supabaseKey = "TU-API-KEY"
```

4. Ejecutar en simulador o dispositivo físico

---

## 📂 Estructura del proyecto

```text
📁 App
📁 Presentation
📁 Domain
📁 Data
📁 Network
📁 DTOs
📁 Resources
```

---

## 📸 Funcionalidades principales

* Login de usuario
* Navegación a pantalla principal
* Consumo de especialidades desde Supabase
* Renderizado dinámico en listas

---

## 🧠 Buenas prácticas aplicadas

* Separación de responsabilidades
* Uso de DTOs para desacoplar backend
* Inyección de dependencias
* Código limpio y mantenible
* Escalable para futuras funcionalidades

---

## 📌 Estado del proyecto

✅ Login funcional
✅ Navegación implementada
✅ Consumo de API desde Supabase
🚧 En desarrollo: gestión de citas médicas, roles (admin/médico/paciente)

---

## 👨‍💻 Autor
**DevEdu**

---

## 📄 Licencia

Este proyecto es de uso educativo y demostrativo.
