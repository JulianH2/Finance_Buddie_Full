using Finansas.Buddie.Data;
using Finansas.Buddie.Infraestructura;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;

namespace Finansas.Buddie.Services
{
    public class MensajesService : IMensajesService
    {
        private readonly FINANZAS_BUDDIEEntities _context;

        public MensajesService()
        {
            _context = new FINANZAS_BUDDIEEntities();
        }

        /// <summary>
        /// Registra una nueva pregunta enviada por un usuario.
        /// </summary>
        /// <param name="mensajeDto">Datos de la pregunta.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        public async Task<bool> CrearPreguntaAsync(MensajeDTO mensajeDto)
        {
            try
            {
                var mensaje = new Mensajes
                {
                    idUsuarioRemitente = mensajeDto.idUsuarioRemitente,
                    contenidoPregunta = mensajeDto.contenidoPregunta,
                    fechaEnvio = DateTime.Now
                };

                _context.Mensajes.Add(mensaje);
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Obtiene todas las preguntas y respuestas registradas.
        /// </summary>
        /// <returns>Lista de mensajes con preguntas y respuestas.</returns>
        public async Task<List<MensajeDTO>> ObtenerMensajesAsync()
        {
            return await _context.Mensajes
                .OrderByDescending(m => m.fechaEnvio)
                .Select(m => new MensajeDTO
                {
                    idMensaje = m.idMensaje,
                    idUsuarioRemitente = m.idUsuarioRemitente.Value,
                    contenidoPregunta = m.contenidoPregunta,
                    contenidoRespuesta = m.contenidoRespuesta,
                    fechaEnvio = m.fechaEnvio.Value
                })
                .ToListAsync();
        }

        /// <summary>
        /// Registra una respuesta para una pregunta existente.
        /// </summary>
        /// <param name="idMensaje">ID del mensaje a responder.</param>
        /// <param name="respuesta">Contenido de la respuesta.</param>
        /// <returns>True si se respondió correctamente; de lo contrario, false.</returns>
        public async Task<bool> ResponderMensajeAsync(int idMensaje, string respuesta)
        {
            try
            {
                var mensaje = await _context.Mensajes.FindAsync(idMensaje);
                if (mensaje == null) return false;

                mensaje.contenidoRespuesta = respuesta;
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Elimina un mensaje (pregunta o respuesta).
        /// </summary>
        /// <param name="idMensaje">ID del mensaje a eliminar.</param>
        /// <returns>True si se eliminó correctamente; de lo contrario, false.</returns>
        public async Task<bool> EliminarMensajeAsync(int idMensaje)
        {
            try
            {
                var mensaje = await _context.Mensajes.FindAsync(idMensaje);
                if (mensaje == null) return false;

                _context.Mensajes.Remove(mensaje);
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}
