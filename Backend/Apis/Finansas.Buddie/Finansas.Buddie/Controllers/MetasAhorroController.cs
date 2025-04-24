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
    [RoutePrefix("api/metasahorro")]
    public class MetasAhorroController : ApiController
    {
        private readonly IMetasAhorroService _metasAhorroService;

        public MetasAhorroController()
        {
            _metasAhorroService = new MetasAhorroService();
        }

        /// <summary>
        /// Crea una nueva meta de ahorro para un usuario.
        /// </summary>
        /// <param name="metaDto">Datos de la meta de ahorro a registrar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPost]
        [Route("crear")]
        public async Task<IHttpActionResult> CrearMetaAhorro([FromBody] MetaAhorroDTO metaDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _metasAhorroService.CrearMetaAhorroAsync(metaDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Meta de ahorro registrada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo registrar la meta de ahorro."
                ));
            }
        }

        /// <summary>
        /// Actualiza los datos de una meta de ahorro.
        /// </summary>
        /// <param name="metaDto">Datos actualizados de la meta de ahorro.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPut]
        [Route("actualizar")]
        public async Task<IHttpActionResult> ActualizarMetaAhorro([FromBody] MetaAhorroDTO metaDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _metasAhorroService.ActualizarMetaAhorroAsync(metaDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Meta de ahorro actualizada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo actualizar la meta de ahorro."
                ));
            }
        }

        /// <summary>
        /// Elimina una meta de ahorro.
        /// </summary>
        /// <param name="idMeta">ID de la meta de ahorro a eliminar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpDelete]
        [Route("eliminar/{idMeta}")]
        public async Task<IHttpActionResult> EliminarMetaAhorro(int idMeta)
        {
            var exito = await _metasAhorroService.EliminarMetaAhorroAsync(idMeta);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Meta de ahorro eliminada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo eliminar la meta de ahorro."
                ));
            }
        }

        /// <summary>
        /// Obtiene todas las metas de ahorro de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de metas de ahorro del usuario.</returns>
        [HttpGet]
        [Route("obtener/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerMetasAhorro(int idUsuario)
        {
            var metasAhorro = await _metasAhorroService.ObtenerMetasAhorroAsync(idUsuario);

            if (metasAhorro != null && metasAhorro.Count > 0)
            {
                return Ok(new ApiResponse<List<MetaAhorroDTO>>(
                    true,
                    "Metas de ahorro obtenidas correctamente.",
                    metasAhorro
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron metas de ahorro."
                ));
            }
        }
    }
}
