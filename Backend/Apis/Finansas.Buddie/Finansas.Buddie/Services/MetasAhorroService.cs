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
    public class MetasAhorroService : IMetasAhorroService
    {
        private readonly FINANZAS_BUDDIEEntities _context;

        public MetasAhorroService()
        {
            _context = new FINANZAS_BUDDIEEntities();
        }
        /// <summary>
        /// Crea una nueva meta de ahorro para un usuario.
        /// </summary>
        /// <param name="metaDto">Datos de la meta a registrar.</param>
        /// <returns>True si se registró correctamente; de lo contrario, false.</returns>
        public async Task<bool> CrearMetaAhorroAsync(MetaAhorroDTO metaDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var meta = new MetasAhorro
                    {
                        idUsuario = metaDto.idUsuario,
                        nombreMeta = metaDto.nombreMeta,
                        descripcion = metaDto.descripcion,
                        montoObjetivo = metaDto.montoObjetivo,
                        montoActual = 0,
                        fechaInicio = DateTime.Now,
                        fechaFin = metaDto.fechaFin,
                        estaCompletada = false,
                        fechaCreacion = DateTime.Now
                    };

                    _context.MetasAhorro.Add(meta);
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
        /// Obtiene todas las metas de ahorro de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario.</param>
        /// <returns>Lista de metas del usuario.</returns>
        public async Task<List<MetaAhorroDTO>> ObtenerMetasAhorroAsync(int idUsuario)
        {
            return await _context.MetasAhorro
                .Where(m => m.idUsuario == idUsuario)
                .Select(m => new MetaAhorroDTO
                {
                    idMeta = m.idMeta,
                    idUsuario = m.idUsuario.Value,
                    nombreMeta = m.nombreMeta,
                    descripcion = m.descripcion,
                    montoObjetivo = m.montoObjetivo,
                    montoActual = m.montoActual.Value,
                    fechaInicio = m.fechaInicio.Value,
                    fechaFin = m.fechaFin,
                    estaCompletada = m.estaCompletada.Value,
                    fechaCreacion = m.fechaCreacion.Value
                })
                .ToListAsync();
        }
        /// <summary>
        /// Actualiza los datos de una meta de ahorro.
        /// </summary>
        /// <param name="metaDto">Datos actualizados de la meta.</param>
        /// <returns>True si se actualizó correctamente; de lo contrario, false.</returns>
        public async Task<bool> ActualizarMetaAhorroAsync(MetaAhorroDTO metaDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var meta = await _context.MetasAhorro.FindAsync(metaDto.idMeta);
                    if (meta == null) return false;

                    meta.nombreMeta = metaDto.nombreMeta;
                    meta.descripcion = metaDto.descripcion;
                    meta.montoObjetivo = metaDto.montoObjetivo;
                    meta.fechaFin = metaDto.fechaFin;
                    meta.estaCompletada = metaDto.estaCompletada;

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
        /// Elimina una meta de ahorro.
        /// </summary>
        /// <param name="idMeta">ID de la meta a eliminar.</param>
        /// <returns>True si se eliminó correctamente; de lo contrario, false.</returns>
        public async Task<bool> EliminarMetaAhorroAsync(int idMeta)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var meta = await _context.MetasAhorro.FindAsync(idMeta);
                    if (meta == null) return false;

                    _context.MetasAhorro.Remove(meta);
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
