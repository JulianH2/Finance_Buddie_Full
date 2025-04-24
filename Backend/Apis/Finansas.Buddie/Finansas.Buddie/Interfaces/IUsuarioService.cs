using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Data;

namespace Finansas.Buddie.Interfaces
{
    public interface IUsuarioService
    {
        /// <summary>
        /// Verifica las credenciales del usuario y realiza el proceso de autenticación.
        /// </summary>
        /// <param name="correo">Correo electrónico del usuario que intenta iniciar sesión.</param>
        /// <param name="contraseña">Contraseña del usuario en texto plano.</param>
        /// <returns>
        /// Un objeto <see cref="UsuarioDTO"/> con los datos del usuario autenticado si las credenciales son válidas;
        /// de lo contrario, retorna null.
        /// </returns>
        Task<UsuarioDTO> LoginAsync(string correo, string contraseña);
        /// <summary>
        /// Registra un nuevo usuario en la base de datos utilizando una transacción.
        /// </summary>
        /// <param name="usuarioDto">Objeto DTO que contiene los datos del usuario a registrar.</param>
        /// <returns>
        /// Retorna un valor booleano que indica si el registro fue exitoso (true) o fallido (false).
        /// </returns>
        Task<bool> RegistrarUsuarioAsync(UsuarioDTO usuarioDto);
    }
}
