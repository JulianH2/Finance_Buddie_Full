import 'dart:convert';
import 'package:finance_buddie/provider/AuthProvider.dart';
import 'package:finance_buddie/utils/ExceptionFilter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/ThemeProvider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nombreController = TextEditingController();

  // Estado del formulario
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    debugPrint('[REGISTER] ===== INICIANDO REGISTRO =====');

    if (!_formKey.currentState!.validate()) {
      debugPrint('[REGISTER] Validación de formulario fallida');
      return;
    }
    debugPrint('[REGISTER] Formulario validado correctamente');

    setState(() => _isLoading = true);
    debugPrint('[REGISTER] Loading activado');

    try {
      debugPrint('[REGISTER] Obteniendo AuthProvider...');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      debugPrint('[REGISTER] Datos de registro:');
      debugPrint('• Nombre: ${_nombreController.text.trim()}');
      debugPrint('• Email: ${_emailController.text.trim()}');
      debugPrint('• Teléfono: ${_telefonoController.text.trim()}');
      debugPrint(
        '• Password: ${_passwordController.text.trim().replaceAll(RegExp(r'.'), '*')}',
      );

      debugPrint('[REGISTER] Enviando solicitud de registro...');
      final response = await authProvider.register(
        _nombreController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _telefonoController.text.trim(),
      );

      debugPrint('[REGISTER] Respuesta del servidor:');
      debugPrint(response.toString());

      if (response.containsKey('success')) {
        debugPrint('[REGISTER] Registro exitoso.}');
        _showSuccessDialog(response);
      } else {
        debugPrint('[REGISTER] Error: La respuesta no contiene idUsuario');
        throw Exception('Respuesta del servidor inválida');
      }
    } catch (e, stackTrace) {
      debugPrint('[REGISTER] Error durante el registro:');
      debugPrint('• Tipo: ${e.runtimeType}');
      debugPrint('• Mensaje: ${e.toString()}');
      debugPrint('[REGISTER] Stack Trace:');
      debugPrint(stackTrace.toString());

      _handleRegistrationError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        debugPrint('[REGISTER] Loading desactivado');
      }
      debugPrint('[REGISTER] ===== FIN DEL REGISTRO =====\n');
    }
  }

  void _showSuccessDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text("Registro exitoso"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tu cuenta ha sido creada correctamente."),
                SizedBox(height: 16),
                Text("ID Usuario: ${userData['idUsuario']}"),
                Text("Nombre: ${userData['nombre']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Regresar al login
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _handleRegistrationError(dynamic error) {
    String errorMessage = "Ocurrió un error durante el registro";

    if (error is ValidationException) {
      errorMessage = error.errors.values.join("\n");
    } else if (error is ApiException) {
      try {
        final errorData = jsonDecode(error.responseBody);
        errorMessage = errorData['message'] ?? error.userMessage;
      } catch (e) {
        errorMessage = error.userMessage;
      }
    } else if (error is NetworkException) {
      errorMessage = "Error de conexión. Intenta conectarte a una red";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor,
              themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            ],
            stops: [0.15, 0.4],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color:
                        themeProvider.isDarkMode
                            ? Color(0xFF2D2D2D)
                            : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Crea tu cuenta para empezar",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          _buildContactInfoStep(themeProvider), // Solo un paso
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "¿Ya tienes una cuenta? ",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                ),
                              ),
                              TextButton(
                                onPressed: _navigateToLogin,
                                child: Text(
                                  "Iniciar sesión",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfoStep(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: "Nombre completo",
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Correo electrónico",
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa tu correo';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _telefonoController,
            decoration: InputDecoration(
              labelText: "Teléfono",
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "10 dígitos",
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Ingresa tu teléfono';
              if (value.length != 10)
                return 'El teléfono debe tener 10 dígitos';
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Contraseña",
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed:
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una contraseña';
              }
              if (value.length < 6) {
                return 'Mínimo 6 caracteres';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: "Confirmar contraseña",
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed:
                    () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirma tu contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child:
                _isLoading
                    ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                    : Text(
                      "Registrarse",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
