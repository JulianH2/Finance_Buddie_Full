using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models
{
    public class MetaAhorroDTO
    {
        public int idMeta { get; set; }

        [Required(ErrorMessage = "El ID del usuario es obligatorio.")]
        public int idUsuario { get; set; }

        [Required(ErrorMessage = "El nombre de la meta es obligatorio.")]
        [StringLength(100, ErrorMessage = "El nombre de la meta no puede tener más de 100 caracteres.")]
        public string nombreMeta { get; set; }

        [StringLength(500, ErrorMessage = "La descripción no puede tener más de 500 caracteres.")]
        public string descripcion { get; set; }

        [Required(ErrorMessage = "El monto objetivo es obligatorio.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto objetivo debe ser mayor a 0.")]
        public decimal montoObjetivo { get; set; }

        public decimal montoActual { get; set; }

        public DateTime fechaInicio { get; set; }

        [Required(ErrorMessage = "La fecha de fin es obligatoria.")]
        public DateTime fechaFin { get; set; }

        public bool estaCompletada { get; set; }

        public DateTime fechaCreacion { get; set; }
    }
}