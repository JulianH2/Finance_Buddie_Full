import 'dart:math' as math;

import 'package:finance_buddie/provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../screens/RegisterScreen.dart';
import '../screens/RecoverPasswordScreen.dart';
import '../screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late AnimationController _bounceController;
  late AnimationController _waveController;
  late AnimationController _successController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<double> _successAnimation;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final List<Particle> particles = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Initialize particles
    for (int i = 0; i < 10; i++) {
      particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * 2 - 1, // -1 to 1
            random.nextDouble() * 2 - 1, // -1 to 1
          ),
          size:
              i < 2
                  ? (i == 0 ? 0.4 : 0.25)
                  : 0.03, // Larger and smaller circles
          speed: Offset(
            (random.nextDouble() - 0.5) * 0.06, // Smoother speed
            (random.nextDouble() - 0.5) * 0.06,
          ),
          opacity: i < 2 ? (i == 0 ? 0.25 : 0.2) : 0.3,
        ),
      );
    }

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _successController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _bounceAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.fastOutSlowIn),
    );

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    _fadeController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    _waveController.dispose();
    _successController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      await _shakeForm();
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response['usuario'] != null &&
          response['usuario'].containsKey('idUsuario')) {
        await _playSuccessAnimation();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutQuint,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          ),
        );
      } else {
        if (!mounted) return;
        _showErrorSnackBar(
          'Credenciales incorrectas. Por favor, verifica tu correo y contraseña.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar(
        'Error al iniciar sesión: No se pudo conectar con el servidor.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _playSuccessAnimation() async {
    await _successController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _successController.reset();
  }

  Future<void> _shakeForm() async {
    final shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final Animation<double> offsetAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(
        parent: shakeController,
        curve: ShakeCurve(count: 8, intensity: 4.0),
      ),
    );

    offsetAnimation.addListener(() {
      setState(() {});
    });

    await shakeController.forward();
    shakeController.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF5350),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        elevation: 6,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => RegisterScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuint),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  void _navigateToRecoverPassword() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => RecoverPasswordScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuint),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF384E74),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeController,
          _backgroundController,
          _waveController,
          _bounceController,
          _successController,
        ]),
        builder: (context, child) {
          // Update particle positions
          for (var particle in particles) {
            particle.position += particle.speed;
            // Wrap particles only when fully off-screen (including size)
            final particleScreenSize = screenSize.width * particle.size;
            final leftEdge =
                (screenSize.width * (particle.position.dx + 1) / 2) -
                particleScreenSize / 2;
            final rightEdge = leftEdge + particleScreenSize;
            final topEdge =
                (screenSize.height * (particle.position.dy + 1) / 2) -
                particleScreenSize / 2;
            final bottomEdge = topEdge + particleScreenSize;

            if (rightEdge < 0) {
              particle.position = Offset(
                2 + particle.size,
                particle.position.dy,
              );
              particle.speed = Offset(
                (random.nextDouble() - 0.5) * 0.06,
                particle.speed.dy,
              );
            } else if (leftEdge > screenSize.width) {
              particle.position = Offset(
                -2 - particle.size,
                particle.position.dy,
              );
              particle.speed = Offset(
                (random.nextDouble() - 0.5) * 0.06,
                particle.speed.dy,
              );
            }
            if (bottomEdge < 0) {
              particle.position = Offset(
                particle.position.dx,
                2 + particle.size,
              );
              particle.speed = Offset(
                particle.speed.dx,
                (random.nextDouble() - 0.5) * 0.06,
              );
            } else if (topEdge > screenSize.height) {
              particle.position = Offset(
                particle.position.dx,
                -2 - particle.size,
              );
              particle.speed = Offset(
                particle.speed.dx,
                (random.nextDouble() - 0.5) * 0.06,
              );
            }
          }

          return Stack(
            children: [
              // Background gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF384E74).withOpacity(0.9),
                        const Color(0xFF1C8A9B).withOpacity(0.7),
                        const Color(0xFF1AE5BE).withOpacity(0.5),
                        Colors.white.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),

              // Wave background
              Positioned.fill(
                child: CustomPaint(
                  painter: WavePainter(
                    color1: const Color(0xFF384E74).withOpacity(0.05),
                    color2: const Color(0xFF1C8A9B).withOpacity(0.05),
                    color3: const Color(0xFF1AE5BE).withOpacity(0.05),
                    animationValue: _waveController.value,
                  ),
                ),
              ),

              // Floating particles
              ...particles.map((particle) {
                return Positioned(
                  left: (screenSize.width * (particle.position.dx + 1) / 2),
                  top: (screenSize.height * (particle.position.dy + 1) / 2),
                  child: Opacity(
                    opacity:
                        particle.opacity *
                        (1 - (_successAnimation.value * 0.5)),
                    child: Container(
                      width: screenSize.width * particle.size,
                      height: screenSize.width * particle.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            particle.size > 0.1
                                ? const Color(
                                  0xFF1AE5BE,
                                ).withOpacity(particle.opacity)
                                : Colors.white.withOpacity(particle.opacity),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1C8A9B).withOpacity(0.2),
                            blurRadius: particle.size * 20,
                            spreadRadius: particle.size * 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          screenSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: isSmallScreen ? 40 : 60),

                          // Title
                          Transform.translate(
                            offset: Offset(0, -_slideAnimation.value),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Transform.scale(
                                scale: 1 - (_successAnimation.value * 0.1),
                                child: Text(
                                  '¡BIENVENIDO!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 36 : 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 4 : 8),

                          // Subtitle
                          Transform.translate(
                            offset: Offset(0, -_slideAnimation.value * 0.8),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Transform.scale(
                                scale: 1 - (_successAnimation.value * 0.1),
                                child: Text(
                                  'Por favor inicia sesión para continuar usando\nFinance Buddie',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontFamily: 'NunitoSans',
                                    height: 1.3,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 30),

                          // Mascot
                          Transform.translate(
                            offset: Offset(
                              0,
                              _bounceAnimation.value *
                                  (1 - _successAnimation.value),
                            ),
                            child: Transform.scale(
                              scale:
                                  _scaleAnimation.value *
                                  (1 + (_successAnimation.value * 0.2)),
                              child: Hero(
                                tag: 'buddie_mascot',
                                child: Image.asset(
                                  'assets/images/buddie_icon.png',
                                  width: isSmallScreen ? 100 : 130,
                                  height: isSmallScreen ? 100 : 130,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildFallbackMascot();
                                  },
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 20 : 30),

                          // Login form
                          Opacity(
                            opacity:
                                _fadeAnimation.value *
                                (1 - (_successAnimation.value * 0.5)),
                            child: Transform.scale(
                              scale: 1 - (_successAnimation.value * 0.1),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email field
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      transform: Matrix4.translationValues(
                                        0,
                                        _isEmailFocused ? -5 : 0,
                                        0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color:
                                              _isEmailFocused
                                                  ? const Color(0xFF1AE5BE)
                                                  : Colors.grey[300]!,
                                          width: _isEmailFocused ? 2 : 1,
                                        ),
                                        boxShadow:
                                            _isEmailFocused
                                                ? [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF1AE5BE,
                                                    ).withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ]
                                                : [],
                                      ),
                                      child: _buildInputField(
                                        controller: _emailController,
                                        focusNode: _emailFocusNode,
                                        label: 'Correo electrónico',
                                        icon: Icons.person_outline,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'El correo electrónico es obligatorio';
                                          }
                                          if (!RegExp(
                                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                          ).hasMatch(value)) {
                                            return 'Por favor, ingresa un correo electrónico válido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Password field
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      transform: Matrix4.translationValues(
                                        0,
                                        _isPasswordFocused ? -5 : 0,
                                        0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color:
                                              _isPasswordFocused
                                                  ? const Color(0xFF1AE5BE)
                                                  : Colors.grey[300]!,
                                          width: _isPasswordFocused ? 2 : 1,
                                        ),
                                        boxShadow:
                                            _isPasswordFocused
                                                ? [
                                                  BoxShadow(
                                                    color: const Color(
                                                      0xFF1AE5BE,
                                                    ).withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ]
                                                : [],
                                      ),
                                      child: _buildInputField(
                                        controller: _passwordController,
                                        focusNode: _passwordFocusNode,
                                        label: 'Contraseña',
                                        icon: Icons.lock_outline,
                                        obscureText: _obscurePassword,
                                        showSuffix: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'La contraseña es obligatoria';
                                          }
                                          if (value.length < 8) {
                                            return 'La contraseña debe tener al menos 8 caracteres';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Forgot password
                                    AnimatedOpacity(
                                      opacity: _buttonFadeAnimation.value,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _navigateToRecoverPassword,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                              child: Text(
                                                '¿Olvidaste tu contraseña?',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontFamily: 'NunitoSans',
                                                  fontSize:
                                                      isSmallScreen ? 14 : 16,
                                                  fontWeight: FontWeight.w500,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 25),

                                    // Login button
                                    AnimatedOpacity(
                                      opacity: _buttonFadeAnimation.value,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: _buildAnimatedButton(
                                        text: 'INICIAR SESIÓN',
                                        onPressed: _login,
                                        isLoading: _isLoading,
                                        isPrimary: true,
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Divider
                                    AnimatedOpacity(
                                      opacity: _buttonFadeAnimation.value,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Text(
                                              'O',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                fontFamily: 'NunitoSans',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Register button
                                    AnimatedOpacity(
                                      opacity: _buttonFadeAnimation.value,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: _buildAnimatedButton(
                                        text: 'CREAR CUENTA',
                                        onPressed: _navigateToRegister,
                                        isPrimary: false,
                                      ),
                                    ),

                                    SizedBox(height: isSmallScreen ? 20 : 30),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFallbackMascot() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF384E74),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.pets, size: 70, color: Colors.white),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    bool showSuffix = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText && _obscurePassword,
      style: const TextStyle(
        color: Color(0xFF384E74),
        fontSize: 16,
        fontFamily: 'NunitoSans',
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[600], fontFamily: 'NunitoSans'),
        prefixIcon: Container(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color:
                focusNode.hasFocus
                    ? const Color(0xFF1AE5BE)
                    : const Color(0xFF384E74),
            size: 22,
          ),
        ),
        suffixIcon:
            showSuffix
                ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
                : null,
        border: InputBorder.none,
        errorStyle: const TextStyle(
          color: Color(0xFFEF5350),
          fontSize: 13,
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        errorMaxLines: 2,
      ),
      validator: validator,
      onChanged: (_) {
        setState(() {});
      },
    );
  }
}

Widget _buildAnimatedButton({
  required String text,
  required VoidCallback onPressed,
  bool isLoading = false,
  bool isPrimary = true,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutBack,
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      color: isPrimary ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      border: isPrimary ? null : Border.all(color: Colors.white, width: 2),
      boxShadow:
          isPrimary
              ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
              : null,
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading ? null : onPressed,
        splashColor:
            isPrimary
                ? const Color(0xFF1AE5BE).withOpacity(0.2)
                : Colors.white.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                isLoading
                    ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF384E74),
                        ),
                      ),
                    )
                    : Text(
                      text,
                      key: ValueKey(text),
                      style: TextStyle(
                        color:
                            isPrimary ? const Color(0xFF384E74) : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        fontFamily: 'Poppins',
                      ),
                    ),
          ),
        ),
      ),
    ),
  );
}

class ShakeCurve extends Curve {
  final int count;
  final double intensity;

  const ShakeCurve({this.count = 3, this.intensity = 1.0});

  @override
  double transformInternal(double t) {
    return math.sin(count * 2 * math.pi * t) * intensity * (1 - t);
  }
}

class Particle {
  Offset position;
  final double size;
  Offset speed;
  final double opacity;

  Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class WavePainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final Color color3;
  final double animationValue;

  WavePainter({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // First wave
    _drawWave(
      canvas: canvas,
      width: width,
      height: height,
      amplitude: 40,
      wavelength: width * 1.2,
      phase: animationValue * 2 * math.pi,
      verticalPosition: height * 0.7,
      color: color1,
    );

    // Second wave
    _drawWave(
      canvas: canvas,
      width: width,
      height: height,
      amplitude: 50,
      wavelength: width * 0.9,
      phase: -animationValue * 2 * math.pi,
      verticalPosition: height * 0.6,
      color: color2,
    );

    // Third wave
    _drawWave(
      canvas: canvas,
      width: width,
      height: height,
      amplitude: 30,
      wavelength: width * 1.5,
      phase: animationValue * 4 * math.pi,
      verticalPosition: height * 0.5,
      color: color3,
    );
  }

  void _drawWave({
    required Canvas canvas,
    required double width,
    required double height,
    required double amplitude,
    required double wavelength,
    required double phase,
    required double verticalPosition,
    required Color color,
  }) {
    final path = Path();
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    path.moveTo(0, verticalPosition);

    for (double x = 0; x <= width; x++) {
      final y =
          verticalPosition +
          amplitude * math.sin((2 * math.pi * x / wavelength) + phase);
      path.lineTo(x, y);
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
