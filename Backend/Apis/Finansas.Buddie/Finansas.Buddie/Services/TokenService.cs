using System;
using System.Data.Entity;
using System.Threading.Tasks;
using Finansas.Buddie.Data;
using Finansas.Buddie.Infraestructura;
using Finansas.Buddie.Interfaces;
using Finansas.Buddie.Models;
using Finansas.Buddie.Models.DTOs;

namespace Finansas.Buddie.Services
{
    public class TokenService : ITokenService
    {
        private readonly FINANZAS_BUDDIEEntities _context = null;

        public TokenService()
        {
            _context = new FINANZAS_BUDDIEEntities();
        }

        public async Task<TokenDTO> ObtenerTokenPorUsuarioAsync(int idUsuario)
        {
            var token = await _context.Token
                .FirstOrDefaultAsync(t => t.idUsuario == idUsuario);

            if (token == null) return null;

            return new TokenDTO
            {
                idToken = token.idToken,
                idUsuario = token.idUsuario,
                token = token.Token1,
                fecha = token.Fecha
            };
        }

        public async Task<bool> GuardarTokenAsync(TokenDTO tokenDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var nuevoToken = new Token
                    {
                        idUsuario = tokenDto.idUsuario,
                        Token1 = tokenDto.token,
                        Fecha = tokenDto.fecha
                    };

                    _context.Token.Add(nuevoToken);
                    await _context.SaveChangesAsync();
                    transaction.Commit();

                    return true;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }

        public async Task<bool> ActualizarTokenAsync(int idToken, TokenDTO tokenDto)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var tokenExistente = await _context.Token.FindAsync(idToken);
                    if (tokenExistente == null) return false;

                    tokenExistente.Token1 = tokenDto.token;
                    tokenExistente.Fecha = tokenDto.fecha;

                    await _context.SaveChangesAsync();
                    transaction.Commit();

                    return true;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    return false;
                }
            }
        }
    }
}
