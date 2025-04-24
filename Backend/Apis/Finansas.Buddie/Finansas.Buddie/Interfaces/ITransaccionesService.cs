using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Models;

namespace Finansas.Buddie.Interfaces
{
    public interface ITransaccionesService
    {
        /// <summary>
        /// Actualiza los datos de una transacción existente.
        /// </summary>
        /// <param name="transaccionDto">Datos actualizados de la transacción.</param>
        /// <returns>True si se actualizó correctamente; de lo contrario, false.</returns>
        Task<bool> ActualizarTransaccionAsync(TransaccionDTO transaccionDto);
        /// <summary>
        /// Crea una nueva transacción y actualiza el historial de saldo del usuario.
        /// </summary>
        /// <param name="transaccionDto">Datos de la transacción a registrar.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        Task<bool> CrearTransaccionAsync(TransaccionDTO transaccionDto);
        /// <summary>
        /// Elimina una transacción del sistema.
        /// </summary>
        /// <param name="idTransaccion">ID de la transacción a eliminar.</param>
        /// <returns>True si se eliminó correctamente; de lo contrario, false.</returns>
        Task<bool> EliminarTransaccionAsync(int idTransaccion);
        /// <summary>
        /// Obtiene el total de ingresos y gastos de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Un diccionario con los totales de ingresos y gastos.</returns>
        Task<Dictionary<string, decimal>> ObtenerTotalesPorTipoAsync(int idUsuario);

        /// <summary>
        /// Obtiene todas las transacciones de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de transacciones del usuario.</returns>
        Task<List<TransaccionDTO>> ObtenerTransaccionesAsync(int idUsuario);

        /// <summary>
        /// Obtiene todas las transacciones de un usuario filtradas por categoría.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <param name="categoria">Nombre de la categoría.</param>
        /// <returns>Lista de transacciones filtradas.</returns>
        Task<List<TransaccionDTO>> ObtenerTransaccionesPorCategoriaAsync(int idUsuario, string categoria);

        Task<Dictionary<string, decimal>> ObtenerGastosPorMesAsync(int idUsuario);

        Task<Dictionary<string, decimal>> ObtenerIngresosPorCategoriaAsync(int idUsuario);

        Task<Dictionary<string, decimal>> ObtenerGastosPorCategoriaAsync(int idUsuario);



    }
}