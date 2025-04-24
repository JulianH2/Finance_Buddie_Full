import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

abstract class AppException implements Exception {
  String get userMessage;
  String get logMessage;
  dynamic get originalError;
}

class NetworkException extends AppException {
  @override
  final String userMessage;
  @override
  final String logMessage;
  @override
  final dynamic originalError;

  NetworkException({
    this.userMessage = 'Error de conexión',
    required this.logMessage,
    this.originalError,
  });
}

class DatabaseException extends AppException {
  final int code;
  @override
  final String logMessage;
  @override
  final dynamic originalError;

  DatabaseException({
    required this.code,
    required this.logMessage,
    this.originalError,
  });

  @override
  String get userMessage {
    switch (code) {
      case 1:
        return 'Registro duplicado';
      case 2:
        return 'Límite de almacenamiento alcanzado';
      default:
        return 'Error en la base de datos';
    }
  }
}

class ValidationException extends AppException {
  final Map<String, String> errors;

  ValidationException(this.errors);

  @override
  String get userMessage => 'Errores de validación';

  @override
  String get logMessage => 'Validation errors: $errors';

  @override
  dynamic get originalError => null;
}

/// Excepción para errores relacionados con archivos.
class FileException extends AppException {
  @override
  final String userMessage;
  @override
  final String logMessage;
  @override
  final dynamic originalError;

  FileException({
    required this.userMessage,
    required this.logMessage,
    this.originalError,
  });
}

/// Excepción para errores en llamadas API (GET, POST, DELETE, etc.).
class ApiException extends AppException {
  final int statusCode;
  final String responseBody;
  @override
  final String logMessage;
  @override
  final dynamic originalError;

  ApiException({
    required this.statusCode,
    required this.responseBody,
    required this.logMessage,
    this.originalError,
  });

  @override
  String get userMessage {
    // Se amplían los casos para incluir errores por datos inválidos y otros códigos comunes.
    switch (statusCode) {
      case 400:
        return 'Correo o Telefono ya Usados ';
      case 401:
        return 'Credenciales invalidas';
      case 403:
        return 'Acceso Denegado';
      case 404:
        return 'No encontrado';
      case 405:
        return 'Método no permitido';
      case 409:
        return 'Conflicto de datos';
      case 422:
        return 'Datos inválidos';
      case 500:
        return 'Error interno del servidor';
      case 503:
        return 'Servicio no disponible';
      default:
        return 'Error en la comunicación con el servidor';
    }
  }
}

/// Excepción genérica para errores no contemplados.
class _GenericException extends AppException {
  @override
  final String userMessage;
  @override
  final String logMessage;
  @override
  final dynamic originalError;

  _GenericException({
    required this.userMessage,
    required this.logMessage,
    this.originalError,
  });
}

/// Manejador central de errores que transforma cualquier error en una instancia de AppException.
class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is AppException) return error;

    // Manejo de excepciones de red.
    if (error is SocketException || error is TimeoutException) {
      return NetworkException(
        logMessage: 'Error de red: ${error.toString()}',
        originalError: error,
      );
    }

    // Manejo de excepciones de plataforma (por ejemplo, errores en archivos).
    if (error is PlatformException) {
      return FileException(
        userMessage: 'Error del sistema',
        logMessage: 'Error de plataforma: ${error.toString()}',
        originalError: error,
      );
    }

    // Por defecto, cualquier otro error se envuelve en una excepción genérica.
    return _GenericException(
      userMessage: 'Error inesperado',
      logMessage: 'Error no manejado: ${error.toString()}',
      originalError: error,
    );
  }
}

// ----------------------------------------------------------------
// Ejemplos de Uso (comentario explicativo)
// ----------------------------------------------------------------

/*
  EJEMPLO DE USO:

  1. Validación de Datos:
     Configura validadores para distintos campos, por ejemplo:

     // Validación de email:
     final emailValidator = FieldValidator<String>([
       const RequiredRule<String>(),
       MaxLengthRule(100),
       CustomRule<String>('Email inválido', (value) {
         final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
         return emailRegex.hasMatch(value);
       }),
     ]);

     // Validación de un campo numérico sin espacios:
     final numericFieldValidator = FieldValidator<String>([
       const RequiredRule<String>(),
       NumbersOnlyRule(),
       NoWhitespaceRule(),
     ]);

     // Validación de imagen:
     final imageValidator = FieldValidator<File>([
       const RequiredRule<File>(),
       FileTypeRule(['image/jpeg', 'image/png']),
       ImageDimensionsRule(1920, 1080),
     ]);

     Luego, en tu formulario, valida cada campo:

     Future<void> validateForm({
       required String email,
       required File selectedFile,
       required String numericInput,
     }) async {
       final emailError = await emailValidator.validate(email);
       final fileError = await imageValidator.validate(selectedFile);
       final numericError = await numericFieldValidator.validate(numericInput);
       
       if (emailError != null || fileError != null || numericError != null) {
         throw ValidationException({
           if (emailError != null) 'email': emailError,
           if (fileError != null) 'imagen': fileError,
           if (numericError != null) 'número': numericError,
         });
       }
     }

  2. Manejo de Excepciones:
     En tu lógica de negocio o llamadas a API, captura las excepciones y utiliza el ErrorHandler:

     Future<void> performApiCall() async {
       try {
         // Realiza la llamada HTTP, por ejemplo:
         // final response = await http.get(Uri.parse('https://api.example.com/data'));
         // if (response.statusCode != 200) {
         //   throw ApiException(
         //     statusCode: response.statusCode,
         //     responseBody: response.body,
         //     logMessage: 'Error en API: ${response.statusCode} ${response.body}',
         //   );
         // }
         // Procesa la respuesta...
       } catch (error) {
         final handledError = ErrorHandler.handle(error);
         // Registra el error:
         print('Log: ${handledError.logMessage}');
         // Muestra el mensaje adecuado al usuario:
         print('Error: ${handledError.userMessage}');
       }
     }

  Así, el sistema centralizado de validación y manejo de excepciones te permite:
  - Verificar la validez de los datos de entrada con reglas reutilizables.
  - Manejar errores de distintos orígenes (red, base de datos, API, archivos) de forma uniforme.
  - Ofrecer mensajes claros al usuario y registrar detalles técnicos para la depuración.
*/
