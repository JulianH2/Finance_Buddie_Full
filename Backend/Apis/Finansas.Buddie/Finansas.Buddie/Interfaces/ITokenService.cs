using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Finansas.Buddie.Models.DTOs;

namespace Finansas.Buddie.Interfaces
{
    public interface ITokenService
    {
        Task<bool> ActualizarTokenAsync(int idToken, TokenDTO tokenDto);
        Task<bool> GuardarTokenAsync(TokenDTO tokenDto);
        Task<TokenDTO> ObtenerTokenPorUsuarioAsync(int idUsuario);
    }
}
