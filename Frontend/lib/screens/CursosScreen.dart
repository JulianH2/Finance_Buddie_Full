import 'package:flutter/material.dart';

class CursosScreen extends StatefulWidget {
  const CursosScreen({super.key});

  @override
  State<CursosScreen> createState() => _CursosScreenState();
}

class _CursosScreenState extends State<CursosScreen> {
  final Set<String> _expandedCategories = {'BÁSICOS'};
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'BÁSICOS',
      'courses': [
        {
          'title': 'Finanzas Personales',
          'description':
              'Aprende los fundamentos para administrar tus finanzas diarias',
          'progress': 0.75,
          'lessons': 8,
          'duration': '3 horas',
          'image': 'assets/images/curso_finanzas_personales.jpg',
          'color': Color(0xFF1AE5BE),
          'instructor': 'María Fernández',
        },
        {
          'title': 'Domina tus Finanzas',
          'description':
              'Estrategias para el control de gastos y ahorro inteligente',
          'progress': 0.35,
          'lessons': 6,
          'duration': '2.5 horas',
          'image': 'assets/images/curso_domina_finanzas.jpg',
          'color': Color(0xFF1C8A9B),
          'instructor': 'Carlos Méndez',
        },
        {
          'title': 'Inteligencia Financiera',
          'description':
              'Maximiza tu potencial económico con decisiones informadas',
          'progress': 0.2,
          'lessons': 12,
          'duration': '4 horas',
          'image': 'assets/images/curso_inteligencia_financiera.jpg',
          'color': Color(0xFF384E74),
          'instructor': 'Ana López',
        },
      ],
    },
    {
      'name': 'INTERMEDIO',
      'courses': [
        {
          'title': 'Inversiones para Principiantes',
          'description': 'Primeros pasos en el mundo de las inversiones',
          'progress': 0.0,
          'lessons': 10,
          'duration': '4.5 horas',
          'image': 'assets/images/curso_inversiones.jpg',
          'color': Color(0xFFFF6B6B),
          'instructor': 'Roberto Sánchez',
        },
        {
          'title': 'Mercados Financieros',
          'description': 'Comprende el funcionamiento de los mercados globales',
          'progress': 0.0,
          'lessons': 9,
          'duration': '3.5 horas',
          'image': 'assets/images/curso_mercados.jpg',
          'color': Color(0xFF4ECDC4),
          'instructor': 'Laura Gómez',
        },
      ],
    },
    {
      'name': 'AVANZADO',
      'courses': [
        {
          'title': 'Trading Profesional',
          'description':
              'Estrategias avanzadas para operar en mercados financieros',
          'progress': 0.0,
          'lessons': 15,
          'duration': '6 horas',
          'image': 'assets/images/curso_trading.jpg',
          'color': Color(0xFFFFD166),
          'instructor': 'Miguel Torres',
        },
        {
          'title': 'Planificación Patrimonial',
          'description': 'Gestión de activos y estrategias a largo plazo',
          'progress': 0.0,
          'lessons': 8,
          'duration': '3 horas',
          'image': 'assets/images/curso_patrimonio.jpg',
          'color': Color(0xFF073B4C),
          'instructor': 'Elena Rodríguez',
        },
      ],
    },
  ];

  void _toggleCategory(String category) {
    setState(() {
      if (_expandedCategories.contains(category)) {
        _expandedCategories.remove(category);
      } else {
        _expandedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Theme.of(context).primaryColor;
    // final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con progreso global
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, Color(0xFF1C8A9B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TU PROGRESO',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '4',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              ' / 12 cursos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 4 / 12,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF1AE5BE),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Barra de búsqueda mejorada
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar cursos...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: primaryColor),
                  suffixIcon: Icon(Icons.mic, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Categorías con cursos
            Text(
              'Categorías',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Listado de categorías mejorado
            ...List.generate(_categories.length, (index) {
              final Map<String, dynamic> category = _categories[index];
              final String name = category['name'];
              final List<dynamic> courses = category['courses'];
              final bool isExpanded = _expandedCategories.contains(name);

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Encabezado de categoría
                    InkWell(
                      onTap: () => _toggleCategory(name),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                        bottom: isExpanded ? Radius.zero : Radius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isExpanded
                                  ? primaryColor.withOpacity(0.1)
                                  : Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                            bottom:
                                isExpanded ? Radius.zero : Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color:
                                    isExpanded
                                        ? primaryColor
                                        : Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    isExpanded ? primaryColor : Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    isExpanded
                                        ? primaryColor.withOpacity(0.1)
                                        : Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: isExpanded ? primaryColor : Colors.grey,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Cursos de la categoría
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: courses.length,
                          itemBuilder: (context, i) {
                            final course = courses[i];
                            return _buildCourseCard(course, context);
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),

            // Cursos recomendados
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recomendados para ti',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Ver todos',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Lista horizontal de cursos recomendados
            Container(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  final recommendations = [
                    _categories[1]['courses'][0],
                    _categories[2]['courses'][0],
                    _categories[0]['courses'][2],
                  ];
                  return Container(
                    width: 280,
                    margin: EdgeInsets.only(right: 16),
                    child: _buildHorizontalCourseCard(
                      recommendations[index],
                      context,
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

  // Widget para las tarjetas de curso
  Widget _buildCourseCard(Map<String, dynamic> course, BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final Color courseColor = course['color'] ?? primaryColor;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            // Navegar al detalle del curso
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del curso
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: courseColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.play_circle_fill,
                      color: courseColor,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Información del curso
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['description'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Detalles del curso
                      Row(
                        children: [
                          _buildCourseDetail(
                            Icons.book,
                            '${course['lessons']} lecciones',
                          ),
                          const SizedBox(width: 12),
                          _buildCourseDetail(
                            Icons.access_time,
                            course['duration'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Barra de progreso
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: course['progress'],
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  courseColor,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${(course['progress'] * 100).toInt()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: courseColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para las tarjetas de curso horizontales
  Widget _buildHorizontalCourseCard(
    Map<String, dynamic> course,
    BuildContext context,
  ) {
    final Color courseColor = course['color'];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [courseColor, courseColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: courseColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navegar al detalle del curso
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador de nivel
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    course == _categories[0]['courses'][2]
                        ? 'BÁSICO'
                        : course == _categories[1]['courses'][0]
                        ? 'INTERMEDIO'
                        : 'AVANZADO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Título del curso
                Text(
                  course['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                // Instructor
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      course['instructor'],
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                // Detalles del curso
                Row(
                  children: [
                    _buildHorizontalCourseDetail(
                      Icons.book,
                      '${course['lessons']} lecciones',
                    ),
                    const SizedBox(width: 12),
                    _buildHorizontalCourseDetail(
                      Icons.access_time,
                      course['duration'],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Botón para empezar
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        color: courseColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Empezar ahora',
                        style: TextStyle(
                          color: courseColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget para detalles del curso
  Widget _buildCourseDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Widget para detalles del curso horizontal
  Widget _buildHorizontalCourseDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}
