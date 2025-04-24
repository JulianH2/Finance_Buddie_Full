using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models
{
    public class MensajeDTO
    {
        public int idMensaje { get; set; }

        [Required(ErrorMessage = "El ID del remitente es obligatorio.")]
        public int idUsuarioRemitente { get; set; }

        [Required(ErrorMessage = "La pregunta es obligatoria.")]
        public string contenidoPregunta { get; set; }

        public string contenidoRespuesta { get; set; }

        public DateTime fechaEnvio { get; set; }
    }
}