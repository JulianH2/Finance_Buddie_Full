using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using Finansas.Buddie.Data;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Models;
using Finansas.Buddie.Models.DTOs;
using Finansas.Buddie.Services;
using Newtonsoft.Json;

namespace Finansas.Buddie.Controllers
{
    [RoutePrefix("api/usuario")]
    public class UsuarioController : ApiController
    {
        private readonly IUsuarioService _usuarioService;
        private readonly ITokenService _tokenService;

        public UsuarioController()
        {
            _usuarioService = new UsuarioService();
            _tokenService = new TokenService();
        }

        /// <summary>
        /// Registra un nuevo usuario en el sistema.
        /// </summary>
        /// <param name="usuarioDto">Datos del usuario a registrar.</param>
        /// <returns>Estado de la operación.</returns>
        [HttpPost]
        [Route("registro")]
        public async Task<IHttpActionResult> Registrar([FromBody] UsuarioDTO usuarioDto)
        {
            if (!ModelState.IsValid)
            {
                
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var exito = await _usuarioService.RegistrarUsuarioAsync(usuarioDto);

            if (exito)
            {
                return Ok(new ApiResponse<object>(
                    true,
                    "Usuario registrado correctamente."
                ));
            }
            else
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "No se pudo registrar el usuario."
                ));
            }
        }

        /// <summary>
        /// Inicia sesión con correo y contraseña.
        /// </summary>
        /// <param name="request">Modelo con correo y contraseña.</param>
        /// <returns>Datos del usuario autenticado si las credenciales son válidas.</returns>
        [HttpPost]
        [Route("login")]
        public async Task<IHttpActionResult> Login([FromBody] LoginRequestModel request)
        {
            if (!ModelState.IsValid)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Datos inválidos.",
                    ModelState
                ));
            }

            var usuario = await _usuarioService.LoginAsync(request.Correo, request.Contraseña);

            if (usuario == null)
            {
                return Content(HttpStatusCode.BadRequest, new ApiResponse<object>(
                    false,
                    "Correo o contraseña incorrectos."
                ));
            }

            
            // Retornar usuario y token juntos
            return Ok(new ApiResponse<object>(
                true,
                "Inicio de sesión exitoso.",
                new
                {
                    usuario
                }
            ));
        }
    }
}
