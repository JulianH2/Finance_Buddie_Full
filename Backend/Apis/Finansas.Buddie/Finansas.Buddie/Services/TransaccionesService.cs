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
    public class TransaccionesService : ITransaccionesService
    {
        private readonly FINANZAS_BUDDIEEntities _context;

        public TransaccionesService()
        {
            _context = new FINANZAS_BUDDIEEntities();
        }

        /// <summary>
        /// Crea una nueva transacción y actualiza el historial de saldo del usuario.
        /// </summary>
        /// <param name="transaccionDto">Datos de la transacción a registrar.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        public async Task<bool> CrearTransaccionAsync(TransaccionDTO transaccionDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var transaccion = new Transacciones
                    {
                        idUsuario = transaccionDto.idUsuario,
                        monto = transaccionDto.monto,
                        tipo = transaccionDto.tipo,
                        fechaOperacion = transaccionDto.fechaOperacion,
                        categoria = transaccionDto.categoria,
                        descripcion = transaccionDto.descripcion,
                        fechaCreacion = DateTime.Now,
                        idMeta = transaccionDto.idMeta
                    };

                    _context.Transacciones.Add(transaccion);

                    // Obtener el último saldo registrado del usuario
                    var ultimoSaldo = await _context.HistorialSaldo
                        .Where(h => h.idUsuario == transaccionDto.idUsuario)
                        .OrderByDescending(h => h.fechaRegistro)
                        .Select(h => h.saldo)
                        .FirstOrDefaultAsync();

                    // Calcular nuevo saldo
                    decimal nuevoSaldo = transaccionDto.tipo == "Ingreso"
                        ? ultimoSaldo + transaccionDto.monto
                        : ultimoSaldo - transaccionDto.monto;

                    // Registrar el nuevo historial de saldo
                    var historial = new HistorialSaldo
                    {
                        idUsuario = transaccionDto.idUsuario,
                        saldo = nuevoSaldo,
                        fechaRegistro = DateTime.Now
                    };

                    _context.HistorialSaldo.Add(historial);

                    await _context.SaveChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        /// <summary>
        /// Obtiene todas las transacciones de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de transacciones del usuario.</returns>
        public async Task<List<TransaccionDTO>> ObtenerTransaccionesAsync(int idUsuario)
        {
            return await _context.Transacciones
                .Where(t => t.idUsuario == idUsuario)
                .Select(t => new TransaccionDTO
                {
                    idTransaccion = t.idTransaccion,
                    idUsuario = t.idUsuario.Value,
                    monto = t.monto,
                    tipo = t.tipo,
                    fechaOperacion = t.fechaOperacion,
                    categoria = t.categoria,
                    descripcion = t.descripcion,
                    fechaCreacion = t.fechaCreacion.Value,
                    idMeta = t.idMeta
                })
                .ToListAsync();
        }

        /// <summary>
        /// Actualiza los datos de una transacción existente.
        /// </summary>
        /// <param name="transaccionDto">Datos actualizados de la transacción.</param>
        /// <returns>True si se actualizó correctamente; de lo contrario, false.</returns>
        public async Task<bool> ActualizarTransaccionAsync(TransaccionDTO transaccionDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var transaccion = await _context.Transacciones.FindAsync(transaccionDto.idTransaccion);
                    if (transaccion == null) return false;

                    // Obtener último saldo
                    var ultimoSaldo = await _context.HistorialSaldo
                        .Where(h => h.idUsuario == transaccionDto.idUsuario)
                        .OrderByDescending(h => h.fechaRegistro)
                        .Select(h => h.saldo)
                        .FirstOrDefaultAsync();

                    // Revertir el saldo con la transacción anterior
                    decimal saldoTemporal = transaccion.tipo == "Ingreso"
                        ? ultimoSaldo - transaccion.monto
                        : ultimoSaldo + transaccion.monto;

                    // Aplicar el nuevo valor
                    decimal nuevoSaldo = transaccionDto.tipo == "Ingreso"
                        ? saldoTemporal + transaccionDto.monto
                        : saldoTemporal - transaccionDto.monto;

                    // Actualizar transacción
                    transaccion.monto = transaccionDto.monto;
                    transaccion.tipo = transaccionDto.tipo;
                    transaccion.fechaOperacion = transaccionDto.fechaOperacion;
                    transaccion.categoria = transaccionDto.categoria;
                    transaccion.descripcion = transaccionDto.descripcion;
                    transaccion.idMeta = transaccionDto.idMeta;

                    // Registrar historial actualizado
                    var historial = new HistorialSaldo
                    {
                        idUsuario = transaccionDto.idUsuario,
                        saldo = nuevoSaldo,
                        fechaRegistro = DateTime.Now
                    };

                    _context.HistorialSaldo.Add(historial);

                    await _context.SaveChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }


        public async Task<bool> EliminarTransaccionAsync(int idTransaccion)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var transaccion = await _context.Transacciones.FindAsync(idTransaccion);
                    if (transaccion == null) return false;

                    int idUsuario = transaccion.idUsuario.Value;

                    // Obtener último saldo
                    var ultimoSaldo = await _context.HistorialSaldo
                        .Where(h => h.idUsuario == idUsuario)
                        .OrderByDescending(h => h.fechaRegistro)
                        .Select(h => h.saldo)
                        .FirstOrDefaultAsync();

                    // Ajustar el saldo eliminando el efecto de la transacción
                    decimal nuevoSaldo = transaccion.tipo == "Ingreso"
                        ? ultimoSaldo - transaccion.monto
                        : ultimoSaldo + transaccion.monto;

                    // Registrar historial con saldo actualizado
                    var historial = new HistorialSaldo
                    {
                        idUsuario = idUsuario,
                        saldo = nuevoSaldo,
                        fechaRegistro = DateTime.Now
                    };

                    _context.HistorialSaldo.Add(historial);

                    // Eliminar la transacción
                    _context.Transacciones.Remove(transaccion);

                    await _context.SaveChangesAsync();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }
        /// <summary>
        /// Obtiene el total de ingresos y gastos de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Un diccionario con los totales de ingresos y gastos.</returns>
        public async Task<Dictionary<string, decimal>> ObtenerTotalesPorTipoAsync(int idUsuario)
        {
            var totales = await _context.Transacciones
                .Where(t => t.idUsuario == idUsuario)
                .GroupBy(t => t.tipo)
                .Select(g => new
                {
                    Tipo = g.Key,
                    Total = g.Sum(t => t.monto)
                })
                .ToListAsync();

            // Inicializar valores en 0 por si no hay registros de un tipo
            decimal totalIngresos = totales.FirstOrDefault(t => t.Tipo == "Ingreso")?.Total ?? 0;
            decimal totalGastos = totales.FirstOrDefault(t => t.Tipo == "Gasto")?.Total ?? 0;

            return new Dictionary<string, decimal>
    {
        { "Ingreso", totalIngresos },
        { "Gasto", totalGastos }
    };
        }

        /// <summary>
        /// Obtiene todas las transacciones de un usuario filtradas por categoría.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <param name="categoria">Nombre de la categoría.</param>
        /// <returns>Lista de transacciones filtradas.</returns>
        public async Task<List<TransaccionDTO>> ObtenerTransaccionesPorCategoriaAsync(int idUsuario, string categoria)
        {
            {
                var query = _context.Transacciones
                    .Where(t => t.idUsuario == idUsuario && t.categoria == categoria)
                    .Select(t => new TransaccionDTO
                    {
                        idTransaccion = t.idTransaccion,
                        idUsuario = t.idUsuario.Value,
                        tipo = t.tipo,
                        monto = t.monto,
                        categoria = t.categoria,
                        descripcion = t.descripcion,
                        fechaOperacion = t.fechaOperacion,
                        fechaCreacion = t.fechaCreacion.Value
                    });

                return await query.ToListAsync();
            }
        }

        public async Task<Dictionary<string, decimal>> ObtenerGastosPorMesAsync(int idUsuario)
        {
            {
                var query = await _context.Transacciones
            .Where(t => t.tipo == "Gasto" && t.idUsuario == idUsuario)
            .GroupBy(t => new { t.fechaOperacion.Year, t.fechaOperacion.Month })
            .Select(g => new
            {
                Mes = g.Key.Year + "-" + (g.Key.Month < 10 ? "0" + g.Key.Month : g.Key.Month.ToString()),
                Total = g.Sum(t => t.monto)
            })
            .ToListAsync();

                return query.ToDictionary(x => x.Mes, x => x.Total);
            }
        }

        public async Task<Dictionary<string, decimal>> ObtenerIngresosPorCategoriaAsync(int idUsuario)
        {
            {
                var ingresos = await _context.Transacciones
                    .Where(t => t.idUsuario == idUsuario && t.tipo.ToLower() == "ingreso")
                    .GroupBy(t => t.categoria)
                    .Select(g => new
                    {
                        Categoria = g.Key,
                        Total = g.Sum(t => t.monto)
                    })
                    .ToDictionaryAsync(x => x.Categoria, x => x.Total);

                return ingresos;
            }
        }

        public async Task<Dictionary<string, decimal>> ObtenerGastosPorCategoriaAsync(int idUsuario)
        {
            {
                var egresos = await _context.Transacciones
                    .Where(t => t.idUsuario == idUsuario && t.tipo.ToLower() == "Gasto")
                    .GroupBy(t => t.categoria)
                    .Select(g => new
                    {
                        Categoria = g.Key,
                        Total = g.Sum(t => t.monto)
                    })
                    .ToDictionaryAsync(x => x.Categoria, x => x.Total);

                return egresos;
            }
        }



    }
}
