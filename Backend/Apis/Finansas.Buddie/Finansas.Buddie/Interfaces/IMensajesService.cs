using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Models;

namespace Finansas.Buddie.Interfaces
{
    public interface IMensajesService
    {
        /// <summary>
        /// Registra una nueva pregunta enviada por un usuario.
        /// </summary>
        /// <param name="mensajeDto">Datos de la pregunta.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        Task<bool> CrearPreguntaAsync(MensajeDTO mensajeDto);
        /// <summary>
        /// Elimina un mensaje (pregunta o respuesta).
        /// </summary>
        /// <param name="idMensaje">ID del mensaje a eliminar.</param>
        /// <returns>True si se eliminó correctamente; de lo contrario, false.</returns>
        Task<bool> EliminarMensajeAsync(int idMensaje);
        /// <summary>
        /// Obtiene todas las preguntas y respuestas registradas.
        /// </summary>
        /// <returns>Lista de mensajes con preguntas y respuestas.</returns>
        Task<List<MensajeDTO>> ObtenerMensajesAsync();
        /// <summary>
        /// Registra una respuesta para una pregunta existente.
        /// </summary>
        /// <param name="idMensaje">ID del mensaje a responder.</param>
        /// <param name="respuesta">Contenido de la respuesta.</param>
        /// <returns>True si se respondió correctamente; de lo contrario, false.</returns>
        Task<bool> ResponderMensajeAsync(int idMensaje, string respuesta);
    }
}
