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
    [RoutePrefix("api/aportacionesmeta")]
    public class AportacionesMetaController : ApiController
    {
        private readonly IAportacionesMetaService _aportacionesMetaService;

        public AportacionesMetaController()
        {
            _aportacionesMetaService = new AportacionesMetaService();
        }

        /// <summary>
        /// Registra una nueva aportación a una meta y actualiza el monto acumulado.
        /// </summary>
        /// <param name="aportacionDto">Datos de la aportación a registrar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPost]
        [Route("crear")]
        public async Task<IHttpActionResult> CrearAportacion([FromBody] AportacionMetaDTO aportacionDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _aportacionesMetaService.CrearAportacionAsync(aportacionDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Aportación registrada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo registrar la aportación."
                ));
            }
        }

        /// <summary>
        /// Actualiza una aportación a una meta.
        /// </summary>
        /// <param name="aportacionDto">Datos actualizados de la aportación.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPut]
        [Route("actualizar")]
        public async Task<IHttpActionResult> ActualizarAportacion([FromBody] AportacionMetaDTO aportacionDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _aportacionesMetaService.ActualizarAportacionAsync(aportacionDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Aportación actualizada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo actualizar la aportación."
                ));
            }
        }

        /// <summary>
        /// Elimina una aportación a una meta.
        /// </summary>
        /// <param name="idAportacion">ID de la aportación a eliminar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpDelete]
        [Route("eliminar/{idAportacion}")]
        public async Task<IHttpActionResult> EliminarAportacion(int idAportacion)
        {
            var exito = await _aportacionesMetaService.EliminarAportacionAsync(idAportacion);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Aportación eliminada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo eliminar la aportación."
                ));
            }
        }

        /// <summary>
        /// Obtiene todas las aportaciones realizadas a una meta.
        /// </summary>
        /// <param name="idMeta">ID de la meta.</param>
        /// <returns>Lista de aportaciones asociadas a la meta.</returns>
        [HttpGet]
        [Route("obtener/{idMeta}")]
        public async Task<IHttpActionResult> ObtenerAportacionesPorMeta(int idMeta)
        {
            var aportaciones = await _aportacionesMetaService.ObtenerAportacionesPorMetaAsync(idMeta);

            if (aportaciones != null && aportaciones.Count > 0)
            {
                return Ok(new ApiResponse<List<AportacionMetaDTO>>(
                    true,
                    "Aportaciones obtenidas correctamente.",
                    aportaciones
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron aportaciones."
                ));
            }
        }
    }
}
