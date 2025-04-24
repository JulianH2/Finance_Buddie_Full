using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models.DTOs
{
    public class TokenDTO
    {
        public int idToken { get; set; }

        [Required(ErrorMessage = "El ID del usuario es obligatorio.")]
        public int idUsuario { get; set; }

        [Required(ErrorMessage = "El Token es obligatorio.")]
        public string token { get; set; }

        [Required(ErrorMessage = "La fecha es obligatoria.")]
        public DateTime fecha { get; set; }

    }
}