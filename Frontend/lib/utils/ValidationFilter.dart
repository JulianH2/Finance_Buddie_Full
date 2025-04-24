import 'dart:async';
import 'dart:io';
import 'package:mime/mime.dart'; // Asegúrate de tener esta dependencia en tu pubspec.yaml

// ----------------------------------------------------------------
// Funciones y Clases Auxiliares (por ejemplo, para decodificar imágenes)
// ----------------------------------------------------------------

// Función auxiliar para decodificar una imagen desde un archivo.
// Debes implementarla según el entorno (Flutter, Dart puro, etc.)
Future<DecodedImage> decodeImageFromFile(String path) async {
  // Ejemplo ficticio: implementa según tus necesidades.
  // final bytes = await File(path).readAsBytes();
  // final codec = await instantiateImageCodec(bytes);
  // final frame = await codec.getNextFrame();
  // return DecodedImage(frame.image.width, frame.image.height);
  throw UnimplementedError(
    'La función decodeImageFromFile no está implementada',
  );
}

// Clase auxiliar para representar las dimensiones de una imagen.
class DecodedImage {
  final int width;
  final int height;
  DecodedImage(this.width, this.height);
}

// ----------------------------------------------------------------
// Sistema de Validación Genérico
// ----------------------------------------------------------------

/// Permite que las validaciones sean sincrónicas o asíncronas.
typedef ValidationResult = FutureOr<bool>;

abstract class ValidationRule<T> {
  final String errorMessage;
  const ValidationRule(this.errorMessage);

  ValidationResult isValid(T value);
}

/// Regla que valida que el campo no sea nulo y, si es String, que no esté vacío.
class RequiredRule<T> extends ValidationRule<T> {
  const RequiredRule({String errorMessage = 'Campo requerido'})
    : super(errorMessage);

  @override
  bool isValid(value) =>
      value != null && (value is! String || value.trim().isNotEmpty);
}

/// Regla que valida la longitud máxima de un String.
class MaxLengthRule extends ValidationRule<String> {
  final int max;
  MaxLengthRule(this.max, {String? errorMessage})
    : super(errorMessage ?? 'Máximo $max caracteres');

  @override
  bool isValid(String value) => value.length <= max;
}

class MinLengthRule extends ValidationRule<String> {
  final int min;
  MinLengthRule(this.min, {String? errorMessage})
    : super(errorMessage ?? 'Máximo $min caracteres');

  @override
  bool isValid(String value) => value.length >= min;
}

/// Regla que impide caracteres no permitidos en un String.
class AllowedCharactersRule extends ValidationRule<String> {
  static const defaultInvalidChars =
      r'''[!@#<>?:.,/\\`~$%^&*(){}[\]"'-+=±§|¿¡]''';
  final RegExp invalidPattern;

  AllowedCharactersRule({String? customInvalidChars, String? errorMessage})
    : invalidPattern = RegExp(customInvalidChars ?? defaultInvalidChars),
      super(errorMessage ?? 'Caracteres no permitidos');

  @override
  bool isValid(String value) => !invalidPattern.hasMatch(value);
}

/// Regla que valida que un String contenga únicamente números.
class NumbersOnlyRule extends ValidationRule<String> {
  NumbersOnlyRule({String? errorMessage})
    : super(errorMessage ?? 'Solo se permiten números');

  @override
  bool isValid(String value) => RegExp(r'^\d+$').hasMatch(value);
}

/// Regla que valida que un String no contenga espacios en blanco.
class NoWhitespaceRule extends ValidationRule<String> {
  NoWhitespaceRule({String? errorMessage})
    : super(errorMessage ?? 'No se permiten espacios en blanco');

  @override
  bool isValid(String value) => !value.contains(' ');
}

/// Regla que valida el tipo MIME de un archivo.
class FileTypeRule extends ValidationRule<File> {
  final List<String> allowedMimeTypes;

  FileTypeRule(this.allowedMimeTypes, {String? errorMessage})
    : super(errorMessage ?? 'Tipo de archivo no permitido');

  @override
  bool isValid(File file) {
    final mimeType = lookupMimeType(file.path);
    return mimeType != null && allowedMimeTypes.contains(mimeType);
  }
}

/// Regla que valida las dimensiones de una imagen (debe ser asíncrona).
class ImageDimensionsRule extends ValidationRule<File> {
  final int maxWidth;
  final int maxHeight;

  ImageDimensionsRule(this.maxWidth, this.maxHeight, {String? errorMessage})
    : super(errorMessage ?? 'La imagen excede las dimensiones permitidas');

  @override
  Future<bool> isValid(File file) async {
    try {
      final decoded = await decodeImageFromFile(file.path);
      return decoded.width <= maxWidth && decoded.height <= maxHeight;
    } catch (e) {
      // Si ocurre un error en la decodificación, se considera fallida la validación.
      return false;
    }
  }
}

/// Regla personalizada que permite definir la lógica de validación mediante una función.
class CustomRule<T> extends ValidationRule<T> {
  final FutureOr<bool> Function(T value) validator;

  CustomRule(String errorMessage, this.validator) : super(errorMessage);

  @override
  FutureOr<bool> isValid(T value) => validator(value);
}

/// Validador genérico que recorre una lista de reglas y retorna el primer error encontrado.
/// Si todas las validaciones pasan, retorna null.
class FieldValidator<T> {
  final List<ValidationRule<T>> rules;

  FieldValidator(this.rules);

  // Versión asíncrona (para otros casos donde se necesite)
  Future<String?> validate(T value) async {
    for (final rule in rules) {
      final result = rule.isValid(value);
      final isValid = result is Future ? await result : result;
      if (!isValid) {
        return rule.errorMessage;
      }
    }
    return null;
  }

  // Versión sincrónica
  String? validateSync(T value) {
    for (final rule in rules) {
      final isValid = rule.isValid(value);
      if (isValid is Future) {
        throw Exception("validateSync no soporta validaciones asíncronas");
      }
      if (!isValid) {
        return rule.errorMessage;
      }
    }
    return null;
  }
}
