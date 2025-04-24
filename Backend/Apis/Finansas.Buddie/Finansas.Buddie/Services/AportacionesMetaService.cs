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
    public class AportacionesMetaService : IAportacionesMetaService
    {
        private readonly FINANZAS_BUDDIEEntities _context;

        public AportacionesMetaService()
        {
            _context = new FINANZAS_BUDDIEEntities();
        }
        /// <summary>
        /// Registra una nueva aportación a una meta y actualiza el monto acumulado.
        /// </summary>
        /// <param name="aportacionDto">Datos de la aportación a registrar.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        public async Task<bool> CrearAportacionAsync(AportacionMetaDTO aportacionDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var meta = await _context.MetasAhorro.FindAsync(aportacionDto.idMeta);
                    if (meta == null) return false;

                    // Registrar la aportación
                    var aportacion = new AportacionesMeta
                    {
                        idMeta = aportacionDto.idMeta,
                        monto = aportacionDto.monto,
                        fechaAportacion = DateTime.Now
                    };
                    _context.AportacionesMeta.Add(aportacion);

                    // Actualizar el montoActual de la meta
                    meta.montoActual += aportacionDto.monto;

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
        /// Obtiene todas las aportaciones realizadas a una meta.
        /// </summary>
        /// <param name="idMeta">ID de la meta.</param>
        /// <returns>Lista de aportaciones asociadas.</returns>
        public async Task<List<AportacionMetaDTO>> ObtenerAportacionesPorMetaAsync(int idMeta)
        {
            return await _context.AportacionesMeta
                .Where(a => a.idMeta == idMeta)
                .Select(a => new AportacionMetaDTO
                {
                    idAportacion = a.idAportacion,
                    idMeta = a.idMeta.Value,
                    monto = a.monto,
                    fechaAportacion = a.fechaAportacion.Value
                })
                .ToListAsync();
        }

        public async Task<bool> ActualizarAportacionAsync(AportacionMetaDTO aportacionDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var aportacion = await _context.AportacionesMeta.FindAsync(aportacionDto.idAportacion);
                    if (aportacion == null) return false;

                    var meta = await _context.MetasAhorro.FindAsync(aportacion.idMeta);
                    if (meta == null) return false;

                    // Restar la aportación anterior
                    meta.montoActual -= aportacion.monto;

                    // Actualizar con la nueva aportación
                    aportacion.monto = aportacionDto.monto;
                    aportacion.fechaAportacion = DateTime.Now;

                    // Sumar la nueva aportación
                    meta.montoActual += aportacionDto.monto;

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

        public async Task<bool> EliminarAportacionAsync(int idAportacion)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var aportacion = await _context.AportacionesMeta.FindAsync(idAportacion);
                    if (aportacion == null) return false;

                    var meta = await _context.MetasAhorro.FindAsync(aportacion.idMeta);
                    if (meta == null) return false;

                    // Restar el monto aportado del total de la meta
                    meta.montoActual -= aportacion.monto;

                    _context.AportacionesMeta.Remove(aportacion);
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
    }
}
