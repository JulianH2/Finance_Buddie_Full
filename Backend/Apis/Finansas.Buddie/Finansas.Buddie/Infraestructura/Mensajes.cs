//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Finansas.Buddie.Infraestructura
{
    using System;
    using System.Collections.Generic;
    
    public partial class Mensajes
    {
        public int idMensaje { get; set; }
        public Nullable<int> idUsuarioRemitente { get; set; }
        public string contenidoPregunta { get; set; }
        public string contenidoRespuesta { get; set; }
        public Nullable<System.DateTime> fechaEnvio { get; set; }
    
        public virtual Usuarios Usuarios { get; set; }
    }
}
