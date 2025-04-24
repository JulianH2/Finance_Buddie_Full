using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models
{
    public class HistorialSaldoDTO
    {
        public int idHistorial { get; set; }

        [Required(ErrorMessage = "El ID del usuario es obligatorio.")]
        public int idUsuario { get; set; }

        [Required(ErrorMessage = "El saldo es obligatorio.")]
        public decimal saldo { get; set; }

        public DateTime fechaRegistro { get; set; }
    }
}