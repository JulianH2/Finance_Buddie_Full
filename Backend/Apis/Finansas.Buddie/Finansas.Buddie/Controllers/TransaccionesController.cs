using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Models;
using Finansas.Buddie.Services;
using Newtonsoft.Json;

namespace Finansas.Buddie.Controllers
{
    [RoutePrefix("api/transacciones")]
    public class TransaccionesController : ApiController
    {
        private readonly ITransaccionesService _transaccionesService;
        private readonly ITokenService _tokenService;


        public TransaccionesController()
        {
            _transaccionesService = new TransaccionesService();
            _tokenService = new TokenService();
        }

        /// <summary>
        /// Crea una nueva transacción y actualiza el historial de saldo del usuario.
        /// </summary>
        /// <param name="transaccionDto">Datos de la transacción a registrar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPost]
        [Route("crear")]
        public async Task<IHttpActionResult> CrearTransaccion([FromBody] TransaccionDTO transaccionDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _transaccionesService.CrearTransaccionAsync(transaccionDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Transacción registrada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo registrar la transacción."
                ));
            }
        }

        /// <summary>
        /// Actualiza los datos de una transacción existente.
        /// </summary>
        /// <param name="transaccionDto">Datos actualizados de la transacción.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPut]
        [Route("actualizar")]
        public async Task<IHttpActionResult> ActualizarTransaccion([FromBody] TransaccionDTO transaccionDto)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _transaccionesService.ActualizarTransaccionAsync(transaccionDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Transacción actualizada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo actualizar la transacción."
                ));
            }
        }

        /// <summary>
        /// Elimina una transacción del sistema.
        /// </summary>
        /// <param name="idTransaccion">ID de la transacción a eliminar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpDelete]
        [Route("eliminar/{idTransaccion}")]
        public async Task<IHttpActionResult> EliminarTransaccion(int idTransaccion)
        {
            var exito = await _transaccionesService.EliminarTransaccionAsync(idTransaccion);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Transacción eliminada correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo eliminar la transacción."
                ));
            }
        }

        /// <summary>
        /// Obtiene todas las transacciones de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de transacciones del usuario.</returns>
        [HttpGet]
        [Route("obtener/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerTransacciones(int idUsuario)
        {
            var transacciones = await _transaccionesService.ObtenerTransaccionesAsync(idUsuario);

            if (transacciones != null && transacciones.Count > 0)
            {
                return Ok(new ApiResponse<List<TransaccionDTO>>(
                    true,
                    "Transacciones obtenidas correctamente.",
                    transacciones
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron transacciones."
                ));
            }
        }

        //[HttpPost]
        //[Route("analizar-texto")]
        //public async Task<IHttpActionResult> AnalizarTextoYCrearTransacciones([FromBody] TextoAnalisis input)
        //{
        //    if (string.IsNullOrWhiteSpace(input.Text) || string.IsNullOrWhiteSpace(input.Tone))
        //    {
        //        return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
        //            false,
        //            "Texto y tono son requeridos."
        //        ));
        //    }

        //    // Obtener token del usuario
        //    var tokenObj = await _tokenService.ObtenerTokenPorUsuarioAsync(input.IdUsuario);
        //    if (tokenObj == null || tokenObj.fecha.AddDays(30) < DateTime.Now)
        //    {
        //        return Content(HttpStatusCode.Unauthorized, new ApiResponse<object>(
        //            false,
        //            "El token del usuario es inválido o ha expirado."
        //        ));
        //    }

        //    var requestBody = new
        //    {
        //        text = input.Text,
        //        tone = input.Tone
        //    };

        //    using (var httpClient = new HttpClient())
        //    {
        //        httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokenObj.token);
        //        httpClient.DefaultRequestHeaders.Add("Accept", "application/json");

        //        var content = new StringContent(JsonConvert.SerializeObject(requestBody), Encoding.UTF8, "application/json");
        //        var response = await httpClient.PostAsync("https://finance-buddie.up.railway.app/analyze-raw-text", content);

        //        if (!response.IsSuccessStatusCode)
        //        {
        //            return Content(HttpStatusCode.InternalServerError, new ApiResponse<object>(
        //                false,
        //                "No se pudo analizar el texto."
        //            ));
        //        }

        //        var jsonResponse = await response.Content.ReadAsStringAsync();
        //        dynamic analysis = JsonConvert.DeserializeObject(jsonResponse);

        //        var transacciones = new List<TransaccionDTO>();
        //        DateTime fechaActual = DateTime.Now;

        //        // INGRESOS
        //        foreach (var ingreso in analysis.summary.ingresos)
        //        {
        //            string moneda = ingreso.Name;
        //            decimal monto = Convert.ToDecimal(((string)ingreso.Value).Split(' ')[0].Replace(",", ""));

        //            transacciones.Add(new TransaccionDTO
        //            {
        //                idUsuario = input.IdUsuario,
        //                tipo = "Ingreso",
        //                monto = monto,
        //                categoria = moneda,
        //                descripcion = $"Ingreso detectado por análisis de texto.",
        //                fechaOperacion = fechaActual,
        //                fechaCreacion = fechaActual
        //            });
        //        }

        //        // EGRESOS
        //        foreach (var egreso in analysis.summary.egresos)
        //        {
        //            string moneda = egreso.Name;
        //            decimal monto = Convert.ToDecimal(((string)egreso.Value).Split(' ')[0].Replace(",", ""));

        //            transacciones.Add(new TransaccionDTO
        //            {
        //                idUsuario = input.IdUsuario,
        //                tipo = "Gasto",
        //                monto = monto,
        //                categoria = moneda,
        //                descripcion = $"Gasto detectado por análisis de texto.",
        //                fechaOperacion = fechaActual,
        //                fechaCreacion = fechaActual
        //            });
        //        }

        //        // Registrar transacciones
        //        bool exito = true;
        //        foreach (var t in transacciones)
        //        {
        //            bool resultado = await _transaccionesService.CrearTransaccionAsync(t);
        //            if (!resultado) exito = false;
        //        }

        //        if (exito)
        //        {
        //            return Ok(new ApiResponse<object>(
        //                true,
        //                "Transacciones registradas desde análisis de texto.",
        //                new
        //                {
        //                    transacciones = transacciones,
        //                    mensaje = (string)analysis.message,
        //                    audio = analysis.audio_info.audio_url
        //                }
        //            ));
        //        }
        //        else
        //        {
        //            return Content(HttpStatusCode.InternalServerError, new ApiResponse<object>(
        //                false,
        //                "Algunas transacciones no pudieron ser registradas."
        //            ));
        //        }
        //    }
        //}

        /// <summary>
        /// Obtiene el total agrupado por tipo de transacción (Ingreso, Gasto) para un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Diccionario con totales por tipo.</returns>
        [HttpGet]
        [Route("totales-por-tipo/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerTotalesPorTipo(int idUsuario)
        {
            var totales = await _transaccionesService.ObtenerTotalesPorTipoAsync(idUsuario);

            if (totales != null && totales.Count > 0)
            {
                return Ok(new ApiResponse<Dictionary<string, decimal>>(
                    true,
                    "Totales obtenidos correctamente.",
                    totales
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron totales para el usuario."
                ));
            }
        }

        /// <summary>
        /// Obtiene todas las transacciones de un usuario filtradas por categoría.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <param name="categoria">Nombre de la categoría.</param>
        /// <returns>Lista de transacciones filtradas.</returns>
        [HttpGet]
        [Route("por-categoria/{idUsuario}/{categoria}")]
        public async Task<IHttpActionResult> ObtenerTransaccionesPorCategoria(int idUsuario, string categoria)
        {
            var transacciones = await _transaccionesService.ObtenerTransaccionesPorCategoriaAsync(idUsuario, categoria);

            if (transacciones != null && transacciones.Count > 0)
            {
                return Ok(new ApiResponse<List<TransaccionDTO>>(
                    true,
                    "Transacciones filtradas por categoría obtenidas correctamente.",
                    transacciones
                ));
            }
            else
            {
                return Content(HttpStatusCode.NotFound, new ApiResponse<object>(
                    false,
                    "No se encontraron transacciones para esta categoría."
                ));
            }
        }

        [HttpGet]
        [Route("gastos-por-mes/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerGastosPorMes(int idUsuario)
        {
            var resultado = await _transaccionesService.ObtenerGastosPorMesAsync(idUsuario);
            return Ok(new ApiResponse<Dictionary<string, decimal>>(true, "Gastos por mes obtenidos", resultado));
        }

        [HttpGet]
        [Route("ingresos-por-categoria/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerIngresosPorCategoria(int idUsuario)
        {
            var resultado = await _transaccionesService.ObtenerIngresosPorCategoriaAsync(idUsuario);
            return Ok(new ApiResponse<Dictionary<string, decimal>>(true, "Ingresos por categoría obtenidos", resultado));
        }

        [HttpGet]
        [Route("gastos-por-categoria/{idUsuario}")]
        public async Task<IHttpActionResult> ObtenerGastosPorCategoria(int idUsuario)
        {
            var resultado = await _transaccionesService.ObtenerGastosPorCategoriaAsync(idUsuario);
            return Ok(new ApiResponse<Dictionary<string, decimal>>(true, "Gastos por categoría obtenidos", resultado));
        }


    }
}
