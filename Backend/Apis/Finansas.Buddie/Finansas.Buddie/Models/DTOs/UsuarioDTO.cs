using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Data
{
    public class UsuarioDTO
    {
        public int idUsuario { get; set; }

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        [StringLength(100, ErrorMessage = "El nombre no puede tener más de 100 caracteres.")]
        public string nombre { get; set; }

        [Required(ErrorMessage = "El correo electrónico es obligatorio.")]
        [EmailAddress(ErrorMessage = "El correo no tiene un formato válido.")]
        [StringLength(255, ErrorMessage = "El correo no puede tener más de 255 caracteres.")]
        public string correo { get; set; }

        [Required(ErrorMessage = "La contraseña es obligatoria.")]
        [StringLength(512, ErrorMessage = "La contraseña no puede tener más de 512 caracteres.")]
        public string hashContraseña { get; set; }

        [Phone(ErrorMessage = "El teléfono no es válido.")]
        [StringLength(20, ErrorMessage = "El teléfono no puede tener más de 20 caracteres.")]
        public string telefono { get; set; }

        public DateTime fechaCreacion { get; set; }

        public bool estaActivo { get; set; }
    }
}