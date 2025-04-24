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
    [RoutePrefix("api/historialsaldo")]
    public class HistorialSaldoController : ApiController
    {
        private readonly IHistorialSaldoService _historialSaldoService;

        public HistorialSaldoController()
        {
            _historialSaldoService = new HistorialSaldoService();
        }

        /// <summary>
        /// Obtiene todo el historial de saldos de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de registros de saldo.</returns>
        [HttpGet]
        [Route("obtener/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerHistorial(int idUsuario)
        {
            var historialSaldo = await _historialSaldoService.ObtenerHistorialAsync(idUsuario);

            if (historialSaldo != null && historialSaldo.Count > 0)
            {
                return Ok(new ApiResponse<List<HistorialSaldoDTO>>(
                    true,
                    "Historial de saldos obtenido correctamente.",
                    historialSaldo
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron registros de saldo."
                ));
            }
        }

        /// <summary>
        /// Obtiene el saldo actual (último registro) del historial de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Último valor de saldo registrado.</returns>
        [HttpGet]
        [Route("obtener/saldoactual/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerSaldoActual(int idUsuario)
        {
            var saldoActual = await _historialSaldoService.ObtenerSaldoActualAsync(idUsuario);

            if (saldoActual >= 0)
            {
                return Ok(new ApiResponse<decimal>(
                    true,
                    "Saldo actual obtenido correctamente.",
                    saldoActual
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se pudo obtener el saldo actual."
                ));
            }
        }
    }
}
