using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Finansas.Buddie.Models
{
    public class ApiResponse<T>
    {
        public bool success { get; set; }
        public string message { get; set; }
        public T data { get; set; }

        public ApiResponse(bool success, string message, T data = default)
        {
            this.success = success;
            this.message = message;
            this.data = data;
        }
    }

}