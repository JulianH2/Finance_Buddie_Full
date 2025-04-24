import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../screens/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _particlesController;
  late AnimationController _rotationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _pulseAnimation;

  final List<Particle> particles = [];
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();

    // Crear más partículas para un efecto visual más rico
    for (int i = 0; i < 20; i++) {
      particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * 2 - 1, // -1 to 1
            random.nextDouble() * 2 - 1, // -1 to 1
          ),
          size:
              i < 3
                  ? (i == 0 ? 0.45 : 0.3)
                  : (random.nextDouble() * 0.05 + 0.03),
          speed: Offset(
            (random.nextDouble() - 0.5) * 0.07,
            (random.nextDouble() - 0.5) * 0.07,
          ),
          opacity:
              i < 3 ? (i == 0 ? 0.3 : 0.25) : (0.2 + random.nextDouble() * 0.2),
        ),
      );
    }

    // Controladores de animación
    _mainController = AnimationController(
      duration: Duration(milliseconds: 2800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(milliseconds: 30000),
      vsync: this,
    );

    // Animaciones
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.2,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_mainController);

    _logoAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.15, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _textAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.5, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_pulseController);

    // Iniciar animaciones
    _mainController.forward();
    _pulseController.repeat();
    _waveController.repeat();
    _particlesController.repeat();
    _rotationController.repeat();

    // Navegar a LoginScreen después de 4.5 segundos
    Timer(Duration(milliseconds: 4500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );

            return FadeTransition(opacity: fadeAnim, child: child);
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _particlesController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Colores mejorados
    final primaryColor = Color(0xFF384E74);
    final secondaryColor = Color(0xFF1C8A9B);
    final accentColor = Color(0xFF1AE5BE);
    final backgroundColor = Color(0xFF384E74).withOpacity(0.92);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              Color(0xFF1C8A9B).withOpacity(0.75),
              Color(0xFF1AE5BE).withOpacity(0.55),
              Colors.white.withOpacity(0.35),
            ],
            stops: [0.0, 0.45, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Ondas de fondo animadas con más detalle
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(
                      color1: primaryColor.withOpacity(0.06),
                      color2: secondaryColor.withOpacity(0.07),
                      color3: accentColor.withOpacity(0.08),
                      animationValue: _waveController.value,
                    ),
                    size: Size(screenSize.width, screenSize.height),
                  );
                },
              ),
            ),

            // Círculo decorativo central
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: screenSize.width * 0.9,
                    height: screenSize.width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withOpacity(0.1),
                          primaryColor.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Partículas flotantes mejoradas
            ...particles.map(
              (particle) => AnimatedBuilder(
                animation: _particlesController,
                builder: (context, child) {
                  // Actualizar posición de las partículas
                  particle.position += particle.speed;

                  // Wrap particles when off-screen
                  if (particle.position.dx < -1)
                    particle.position = Offset(1, particle.position.dy);
                  if (particle.position.dx > 1)
                    particle.position = Offset(-1, particle.position.dy);
                  if (particle.position.dy < -1)
                    particle.position = Offset(particle.position.dx, 1);
                  if (particle.position.dy > 1)
                    particle.position = Offset(particle.position.dx, -1);

                  return Positioned(
                    left: (screenSize.width * (particle.position.dx + 1) / 2),
                    top: (screenSize.height * (particle.position.dy + 1) / 2),
                    child: Opacity(
                      opacity:
                          particle.opacity *
                          (0.6 +
                              0.4 *
                                  math.sin(
                                    _particlesController.value * math.pi * 2,
                                  )),
                      child: Container(
                        width: screenSize.width * particle.size,
                        height: screenSize.width * particle.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              particle.size > 0.1
                                  ? accentColor.withOpacity(
                                    particle.opacity * 1.2,
                                  )
                                  : Colors.white.withOpacity(
                                    particle.opacity * 1.2,
                                  ),
                              particle.size > 0.1
                                  ? accentColor.withOpacity(0.0)
                                  : Colors.white.withOpacity(0.0),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: secondaryColor.withOpacity(0.3),
                              blurRadius: particle.size * 25,
                              spreadRadius: particle.size * 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Contenido principal centrado con logo más grande
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animado más grande
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _mainController,
                      _pulseController,
                    ]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -_logoAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            width: 340, // Aumentado de 300 a 340
                            height: 340, // Aumentado de 300 a 340
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(.15),
                                  blurRadius: 25,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Transform.scale(
                                scale:
                                    _scaleAnimation.value *
                                    _pulseAnimation.value,
                                child: Hero(
                                  tag: 'buddie_mascot',
                                  child: Container(
                                    width: 250, // Aumentado de 180 a 250
                                    height: 250, // Aumentado de 180 a 250
                                    child: AnimatedBuilder(
                                      animation: _rotationController,
                                      builder: (context, child) {
                                        // Efecto sutil de rotación
                                        return Transform.rotate(
                                          angle:
                                              math.sin(
                                                _rotationController.value *
                                                    math.pi *
                                                    2,
                                              ) *
                                              0.03,
                                          child: Image.asset(
                                            'assets/images/buddie_icon.png',
                                            color: Colors.white.withOpacity(
                                              0.95,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 50), // Aumentado el espacio
                  // Texto con animación mejorada
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                "Finance Buddie",
                                style: TextStyle(
                                  fontSize: 42, // Aumentado de 38 a 42
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.7,
                                  shadows: [
                                    Shadow(
                                      color: primaryColor.withOpacity(0.7),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                    Shadow(
                                      color: accentColor.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15), // Aumentado
                              Text(
                                "Tu asistente financiero personal",
                                style: TextStyle(
                                  fontSize: 18, // Aumentado de 16 a 18
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.95),
                                  fontFamily: 'NunitoSans',
                                  letterSpacing: 0.6,
                                  shadows: [
                                    Shadow(
                                      color: secondaryColor.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Barra de progreso inferior mejorada
            Positioned(
              bottom: 70, // Aumentado de 60 a 70
              left:
                  screenSize.width *
                  0.2, // Cambiado de 0.25 a 0.2 para hacerla más ancha
              right: screenSize.width * 0.2,
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      height: 5, // Aumentado de 4 a 5
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _mainController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                secondaryColor,
                                accentColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Mensaje de carga
            Positioned(
              bottom: 40, // Posición por debajo de la barra de progreso
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Center(
                      child: Text(
                        "Cargando tu experiencia financiera...",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: 'NunitoSans',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      amplitude: 45, // Aumentado de 40 a 45
      wavelength: width * 1.3, // Aumentado de 1.2 a 1.3
      phase: animationValue * 2 * math.pi,
      verticalPosition: height * 0.7,
      color: color1,
    );

    // Second wave
    _drawWave(
      canvas: canvas,
      width: width,
      height: height,
      amplitude: 55, // Aumentado de 50 a 55
      wavelength: width * 0.95, // Aumentado de 0.9 a 0.95
      phase: -animationValue * 2 * math.pi,
      verticalPosition: height * 0.65, // Cambiado de 0.6 a 0.65
      color: color2,
    );

    // Third wave
    _drawWave(
      canvas: canvas,
      width: width,
      height: height,
      amplitude: 35, // Aumentado de 30 a 35
      wavelength: width * 1.6, // Aumentado de 1.5 a 1.6
      phase: animationValue * 4 * math.pi,
      verticalPosition: height * 0.55, // Cambiado de 0.5 a 0.55
      color: color3,
    );

    // Cuarta onda (nueva)
    _drawWave(
      canvas: canvas,
      width: width,
      height: height,
      amplitude: 25,
      wavelength: width * 0.8,
      phase: -animationValue * 3 * math.pi,
      verticalPosition: height * 0.45,
      color: color1.withOpacity(0.5),
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
