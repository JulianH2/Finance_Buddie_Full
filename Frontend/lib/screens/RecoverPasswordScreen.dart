import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ThemeProvider.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _recoverPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Aquí implementarías la recuperación de contraseña con tu AuthService
        // Por ejemplo:
        // await _authService.sendPasswordResetEmail(_emailController.text.trim());

        // Simulando el envío para fines de demostración
        await Future.delayed(Duration(seconds: 2));

        setState(() {
          _isLoading = false;
          _emailSent = true;
        });

        _showSnackBar(
          "Se ha enviado un correo con instrucciones para restablecer tu contraseña",
        );
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar("Error al enviar correo: $e");
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final primaryColor = themeProvider.primaryColor;
    final secondaryColor = themeProvider.secondaryColor;
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      // Quitamos el AppBar para eliminar la flecha de regreso
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
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: child,
              ),
            );
          },
          child: SafeArea(
            child: Column(
              children: [
                // Custom back button en vez de AppBar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        "Recuperar Contraseña",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                          child:
                              _emailSent
                                  ? _buildSuccessMessage(
                                    primaryColor,
                                    textColor,
                                  )
                                  : _buildRecoverForm(
                                    primaryColor,
                                    secondaryColor,
                                    textColor,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecoverForm(
    Color primaryColor,
    Color secondaryColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.lock_reset, size: 70, color: primaryColor),
        SizedBox(height: 20),
        Text(
          "¿Olvidaste tu contraseña?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Ingresa tu correo electrónico y te enviaremos instrucciones para restablecer tu contraseña",
          style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),

        // Campo de correo electrónico
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Correo electrónico",
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor ingresa tu correo';
            }
            final emailRegex = RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            );
            if (!emailRegex.hasMatch(value)) {
              return 'Ingresa un correo válido';
            }
            return null;
          },
        ),
        SizedBox(height: 30),

        // Botón de enviar
        Container(
          height: 55,
          child:
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _recoverPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Enviar Instrucciones",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ),

        SizedBox(height: 20),

        // Volver a iniciar sesión
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿Recordaste tu contraseña? ",
              style: TextStyle(color: textColor.withOpacity(0.7)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
    );
  }

  Widget _buildSuccessMessage(Color primaryColor, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        SizedBox(height: 20),
        Text(
          "¡Correo enviado!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Hemos enviado las instrucciones para restablecer tu contraseña a ${_emailController.text}",
          style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.8)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Revisa tu bandeja de entrada o carpeta de spam.",
          style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "Volver a Iniciar Sesión",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
