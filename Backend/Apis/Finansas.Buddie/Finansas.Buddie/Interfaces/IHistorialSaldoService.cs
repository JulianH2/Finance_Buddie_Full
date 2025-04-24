using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Models;

namespace Finansas.Buddie.Interfaces
{
    public interface IHistorialSaldoService
    {
        /// <summary>
        /// Obtiene todo el historial de saldos de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de registros de saldo.</returns>
        Task<List<HistorialSaldoDTO>> ObtenerHistorialAsync(int idUsuario);
        /// <summary>
        /// Obtiene el saldo actual (último registro) del historial de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Último valor de saldo registrado.</returns>
        Task<decimal> ObtenerSaldoActualAsync(int idUsuario);
    }
}
