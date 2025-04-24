using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Models;
using Finansas.Buddie.Services;

namespace Finansas.Buddie.Controllers
{
    [RoutePrefix("api/mensajes")]
    public class MensajesController : ApiController
    {
        private readonly IMensajesService _mensajesService;

        public MensajesController()
        {
            _mensajesService = new MensajesService();
        }

        /// <summary>
        /// Registra una nueva pregunta enviada por un usuario.
        /// </summary>
        /// <param name="mensajeDto">Datos de la pregunta.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPost]
        [Route("pregunta")]
        public async Task<IHttpActionResult> CrearPregunta([FromBody] MensajeDTO mensajeDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _mensajesService.CrearPreguntaAsync(mensajeDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Pregunta registrada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo registrar la pregunta."
                ));
            }
        }

        /// <summary>
        /// Elimina un mensaje (pregunta o respuesta).
        /// </summary>
        /// <param name="idMensaje">ID del mensaje a eliminar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpDelete]
        [Route("eliminar/{idMensaje}")]
        public async Task<IHttpActionResult> EliminarMensaje(int idMensaje)
        {
            var exito = await _mensajesService.EliminarMensajeAsync(idMensaje);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Mensaje eliminado correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo eliminar el mensaje."
                ));
            }
        }

        /// <summary>
        /// Obtiene todas las preguntas y respuestas registradas.
        /// </summary>
        /// <returns>Lista de mensajes con preguntas y respuestas.</returns>
        [HttpGet]
        [Route("obtener")]
        public async Task<IHttpActionResult> ObtenerMensajes()
        {
            var mensajes = await _mensajesService.ObtenerMensajesAsync();

            if (mensajes != null && mensajes.Count > 0)
            {
                return Ok(new ApiResponse<List<MensajeDTO>>(
                    true,
                    "Mensajes obtenidos correctamente.",
                    mensajes
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron mensajes registrados."
                ));
            }
        }

        /// <summary>
        /// Registra una respuesta para una pregunta existente.
        /// </summary>
        /// <param name="idMensaje">ID del mensaje a responder.</param>
        /// <param name="respuesta">Contenido de la respuesta.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPut]
        [Route("respuesta/{idMensaje}")]
        public async Task<IHttpActionResult> ResponderMensaje(int idMensaje, [FromBody] string respuesta)
        {
            if (string.IsNullOrEmpty(respuesta))
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "La respuesta no puede estar vacía."
                ));
            }

            var exito = await _mensajesService.ResponderMensajeAsync(idMensaje, respuesta);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Respuesta registrada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo registrar la respuesta."
                ));
            }
        }
    }
}
