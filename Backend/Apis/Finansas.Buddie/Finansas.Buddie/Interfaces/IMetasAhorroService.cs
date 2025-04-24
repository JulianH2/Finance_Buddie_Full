using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Models;

namespace Finansas.Buddie.Interfaces
{
    public interface IMetasAhorroService
    {
        /// <summary>
        /// Actualiza los datos de una meta de ahorro.
        /// </summary>
        /// <param name="metaDto">Datos actualizados de la meta.</param>
        /// <returns>True si se actualizó correctamente; de lo contrario, false.</returns>
        Task<bool> ActualizarMetaAhorroAsync(MetaAhorroDTO metaDto);
        /// <summary>
        /// Crea una nueva meta de ahorro para un usuario.
        /// </summary>
        /// <param name="metaDto">Datos de la meta a registrar.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        Task<bool> CrearMetaAhorroAsync(MetaAhorroDTO metaDto);
        /// <summary>
        /// Elimina una meta de ahorro.
        /// </summary>
        /// <param name="idMeta">ID de la meta a eliminar.</param>
        /// <returns>True si se eliminó correctamente; de lo contrario, false.</returns>
        Task<bool> EliminarMetaAhorroAsync(int idMeta);
        /// <summary>
        /// Obtiene todas las metas de ahorro de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de metas del usuario.</returns>
        Task<List<MetaAhorroDTO>> ObtenerMetasAhorroAsync(int idUsuario);
    }
}
