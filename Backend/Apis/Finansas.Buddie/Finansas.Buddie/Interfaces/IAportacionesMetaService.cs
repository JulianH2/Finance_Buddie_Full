using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Models;

namespace Finansas.Buddie.Interfaces
{
    public interface IAportacionesMetaService
    {
        Task<bool> ActualizarAportacionAsync(AportacionMetaDTO aportacionDto);
        /// <summary>
        /// Registra una nueva aportación a una meta y actualiza el monto acumulado.
        /// </summary>
        /// <param name="aportacionDto">Datos de la aportación a registrar.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        Task<bool> CrearAportacionAsync(AportacionMetaDTO aportacionDto);
        Task<bool> EliminarAportacionAsync(int idAportacion);
        /// <summary>
        /// Obtiene todas las aportaciones realizadas a una meta.
        /// </summary>
        /// <param name="idMeta">ID de la meta.</param>
        /// <returns>Lista de aportaciones asociadas.</returns>
        Task<List<AportacionMetaDTO>> ObtenerAportacionesPorMetaAsync(int idMeta);
    }
}
