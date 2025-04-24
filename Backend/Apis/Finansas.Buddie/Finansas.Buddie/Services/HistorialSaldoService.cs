using Finansas.Buddie.Data;
using Finansas.Buddie.Infraestructura;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;

namespace Finansas.Buddie.Services
{
    public class HistorialSaldoService : IHistorialSaldoService
    {
        private readonly FINANZAS_BUDDIEEntities _context;

        public HistorialSaldoService()
        {
            _context = new FINANZAS_BUDDIEEntities();
        }

        /// <summary>
        /// Obtiene todo el historial de saldos de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de registros de saldo.</returns>
        public async Task<List<HistorialSaldoDTO>> ObtenerHistorialAsync(int idUsuario)
        {
            return await _context.HistorialSaldo
                .Where(h => h.idUsuario == idUsuario)
                .OrderByDescending(h => h.fechaRegistro)
                .Select(h => new HistorialSaldoDTO
                {
                    idHistorial = h.idHistorial,
                    idUsuario = h.idUsuario.Value,
                    saldo = h.saldo,
                    fechaRegistro = h.fechaRegistro.Value
                })
                .ToListAsync();
        }

        /// <summary>
        /// Obtiene el saldo actual (último registro) del historial de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Último valor de saldo registrado.</returns>
        public async Task<decimal> ObtenerSaldoActualAsync(int idUsuario)
        {
            return await _context.HistorialSaldo
                .Where(h => h.idUsuario == idUsuario)
                .OrderByDescending(h => h.fechaRegistro)
                .Select(h => h.saldo)
                .FirstOrDefaultAsync();
        }
    }
}
