using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models
{
    public class TransaccionDTO
    {
        public int idTransaccion { get; set; }

        [Required(ErrorMessage = "El ID del usuario es obligatorio.")]
        public int idUsuario { get; set; }

        [Required(ErrorMessage = "El monto de la transacción es obligatorio.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto debe ser mayor a 0.")]
        public decimal monto { get; set; }

        [Required(ErrorMessage = "El tipo de transacción es obligatorio.")]
        [RegularExpression("Ingreso|Gasto", ErrorMessage = "El tipo debe ser 'Ingreso' o 'Gasto'.")]
        public string tipo { get; set; }

        [Required(ErrorMessage = "La fecha de operación es obligatoria.")]
        public DateTime fechaOperacion { get; set; }

        [StringLength(50, ErrorMessage = "La categoría no puede tener más de 50 caracteres.")]
        public string categoria { get; set; }

        [StringLength(500, ErrorMessage = "La descripción no puede tener más de 500 caracteres.")]
        public string descripcion { get; set; }

        public DateTime fechaCreacion { get; set; }

        public int? idMeta { get; set; }
    }
}