using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using Finansas.Buddie.Data;
using System.Threading.Tasks;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Infraestructura;
using System.Data.Entity;


namespace Finansas.Buddie.Services
{

    public class UsuarioService : IUsuarioService
    {
        private readonly FINANZAS_BUDDIEEntities _context = null;

        public UsuarioService()
        {
            this._context = new FINANZAS_BUDDIEEntities();
        }

        /// <summary>
        /// Registra un nuevo usuario en la base de datos utilizando una transacción.
        /// </summary>
        /// <param name="usuarioDto">Objeto DTO que contiene los datos del usuario a registrar.</param>
        /// <returns>
        /// Retorna un valor booleano que indica si el registro fue exitoso (true) o fallido (false).
        /// </returns>
        public async Task<bool> RegistrarUsuarioAsync(UsuarioDTO usuarioDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var usuario = new Usuarios
                    {
                        nombre = usuarioDto.nombre,
                        correo = usuarioDto.correo,
                        hashContraseña = HashPassword(usuarioDto.hashContraseña),
                        telefono = usuarioDto.telefono,
                        fechaCreacion = DateTime.Now,
                        estaActivo = true
                    };

                    _context.Usuarios.Add(usuario);
                    await _context.SaveChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        /// <summary>
        /// Verifica las credenciales del usuario y realiza el proceso de autenticación.
        /// </summary>
        /// <param name="correo">Correo electrónico del usuario que intenta iniciar sesión.</param>
        /// <param name="contraseña">Contraseña del usuario en texto plano.</param>
        /// <returns>
        /// Un objeto <see cref="UsuarioDTO"/> con los datos del usuario autenticado si las credenciales son válidas;
        /// de lo contrario, retorna null.
        /// </returns>
        public async Task<UsuarioDTO> LoginAsync(string correo, string contraseña)
        {
            var usuario = await _context.Usuarios
    .Where(u => u.correo == correo && u.estaActivo == true)
    .FirstOrDefaultAsync();

            if (usuario != null && VerifyPassword(contraseña, usuario.hashContraseña))
            {
                return new UsuarioDTO
                {
                    idUsuario = usuario.idUsuario,
                    nombre = usuario.nombre,
                    correo = usuario.correo,
                    telefono = usuario.telefono,
                    fechaCreacion = usuario.fechaCreacion.Value,
                    estaActivo = usuario.estaActivo.Value
                };
            }

            return null;
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(bytes);
            }
        }

        private bool VerifyPassword(string input, string hashed)
        {
            var contraseña = HashPassword(input);
            return contraseña == hashed;
        }
    }
}

