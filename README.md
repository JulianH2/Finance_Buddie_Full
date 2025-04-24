# FinanceBuddie 💰🤖

<p align="center">
  <img src="Logo_.png" alt="FinanceBuddie Logo" width="200"/>
</p>

> Tu asesor financiero inteligente, accesible e inclusivo.  
> Educación financiera con IA para todos.

---

## 📌 Descripción

**FinanceBuddie** es una aplicación móvil que democratiza el acceso a la educación financiera mediante herramientas inteligentes y accesibles. Diseñada especialmente para personas con baja alfabetización financiera, ofrece:

- 🧠 **Análisis automatizado** de transacciones usando IA
- 📊 **Recomendaciones personalizadas** basadas en hábitos de gasto
- 🔊 **Síntesis de voz** para entender conceptos clave fácilmente
- 🌍 **Enfoque inclusivo** alineado con [ODS 8 - Trabajo decente y crecimiento económico](https://www.un.org/sustainabledevelopment/economic-growth/)

---

## 🛠️ Stack Tecnológico

### Backend (Versión actual: temporal/prototipo)

| Componente         | Tecnología             | Uso                                       |
|--------------------|------------------------|-------------------------------------------|
| **API Core**       | Python + FastAPI       | Lógica de negocio y definición de endpoints |
| **IA/ML**          | OpenAI GPT-3.5 Turbo   | Análisis de gastos, generación de insights |
| **Texto a voz (TTS)** | OpenAI TTS           | Audios explicativos para el usuario        |
| **Almacenamiento** | Azure Blob Storage     | Almacenamiento seguro de audios e informes |

### Frontend (Producción)

| Componente         | Tecnología             | Uso                                       |
|--------------------|------------------------|-------------------------------------------|
| **App móvil**      | Flutter                | Interfaz intuitiva y multiplataforma       |
| **Autenticación**  | Amazon Cognito         | Registro, login y gestión de sesiones      |
| **Consumo de API** | HTTP + Provider (Flutter) | Conexión eficiente con servicios backend |

---

