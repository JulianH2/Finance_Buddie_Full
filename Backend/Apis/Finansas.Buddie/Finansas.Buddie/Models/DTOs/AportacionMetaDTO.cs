using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models
{
    public class AportacionMetaDTO
    {
        public int idAportacion { get; set; }

        [Required(ErrorMessage = "El ID de la meta es obligatorio.")]
        public int idMeta { get; set; }

        [Required(ErrorMessage = "El monto de la aportación es obligatorio.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto de la aportación debe ser mayor a 0.")]
        public decimal monto { get; set; }

        public DateTime fechaAportacion { get; set; }
    }
}