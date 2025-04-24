class Constantes {
  static const String baseUrl = 'https://finanzasbuddie.bsite.net/';

  // Usuario
  static const String login = '${baseUrl}api/usuario/login';
  static const String registro = '${baseUrl}api/usuario/registro';

  // Transacciones
  static const String crearTransaccion = '${baseUrl}api/transacciones/crear';
  static const String actualizarTransaccion =
      '${baseUrl}api/transacciones/actualizar';
  static const String eliminarTransaccion =
      '${baseUrl}api/transacciones/eliminar';
  static const String obtenerTransacciones =
      '${baseUrl}api/transacciones/obtener';
  static const String totalesPorTipo =
      '${baseUrl}api/transacciones/totales-por-tipo';
  static const String transaccionesPorCategoria =
      '${baseUrl}api/transacciones/por-categoria';
  static const String gastosPorMes =
      '${baseUrl}api/transacciones/gastos-por-mes';
  static const String ingresosPorCategoria =
      '${baseUrl}api/transacciones/ingresos-por-categoria';
  static const String gastosPorCategoria =
      '${baseUrl}api/transacciones/gastos-por-categoria';

  // Mensajes
  static const String enviarMensaje = '${baseUrl}api/mensajes/pregunta';
  static const String eliminarMensaje = '${baseUrl}api/mensajes/eliminar';
  static const String obtenerMensajes = '${baseUrl}api/mensajes/obtener';
  static const String responderMensaje = '${baseUrl}api/mensajes/respuesta';

  // Historial de saldo
  static const String obtenerHistorialSaldo =
      '${baseUrl}api/historialsaldo/obtener';
  static const String obtenerSaldoActual =
      '${baseUrl}api/historialsaldo/obtener/saldoactual';

  // AportacionesMeta
  static const String crearAportacion = '${baseUrl}api/aportacionesmeta/crear';
  static const String actualizarAportacion =
      '${baseUrl}api/aportacionesmeta/actualizar';
  static const String eliminarAportacion =
      '${baseUrl}api/aportacionesmeta/eliminar';
  static const String obtenerAportaciones =
      '${baseUrl}api/aportacionesmeta/obtener';

  // MetasAhorro
  static const String crearMeta = '${baseUrl}api/metasahorro/crear';
  static const String actualizarMeta = '${baseUrl}api/metasahorro/actualizar';
  static const String eliminarMeta = '${baseUrl}api/metasahorro/eliminar';
  static const String obtenerMetas = '${baseUrl}api/metasahorro/obtener';
}
