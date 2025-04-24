import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/ThemeProvider.dart';
import 'LoginScreen.dart';
import 'BuddieScreen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.textColor),
        ),
        elevation: 0,
        backgroundColor: theme.surfaceColor,
        iconTheme: IconThemeData(color: theme.appBarIconColor),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: theme.secondaryColor),
            onPressed: () {
              // Acción para editar perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo en la parte superior
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Image.asset(
                'assets/images/buddie_icon.png',
                width: 100,
                height: 100,
              ),
            ),

            // Sección Mi Buddie
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: theme.cardColor,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BuddieScreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/buddie_icon.png',
                          width: 60,
                          height: 60,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mi Buddie',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Nivel 5 - 3 medallas',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  color: theme.hintTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: theme.hintTextColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Tarjeta de perfil
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: theme.cardColor,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.secondaryColor.withOpacity(0.2),
                        backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/men/41.jpg',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Juan Pérez',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'juan.perez@example.com',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: theme.hintTextColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(color: theme.dividerColor),
                      SizedBox(height: 16),
                      _buildProfileInfoRow(
                        context,
                        theme,
                        icon: Icons.phone,
                        title: 'Teléfono',
                        value: '+52 55 1234 5678',
                      ),
                      _buildProfileInfoRow(
                        context,
                        theme,
                        icon: Icons.location_on,
                        title: 'Dirección',
                        value: 'Av. Insurgentes 123, CDMX',
                      ),
                      _buildProfileInfoRow(
                        context,
                        theme,
                        icon: Icons.calendar_today,
                        title: 'Miembro desde',
                        value: 'Enero 2022',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sección de configuración rápida
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: theme.cardColor,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: theme.secondaryColor,
                      ),
                      title: Text(
                        'Notificaciones',
                        style: GoogleFonts.nunitoSans(
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: theme.secondaryColor,
                      ),
                    ),
                    Divider(color: theme.dividerColor, height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.visibility,
                        color: theme.secondaryColor,
                      ),
                      title: Text(
                        'Modo oscuro',
                        style: GoogleFonts.nunitoSans(
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Switch(
                        value: theme.isDarkMode,
                        onChanged: (value) => theme.toggleTheme(value),
                        activeColor: theme.secondaryColor,
                      ),
                    ),
                    Divider(color: theme.dividerColor, height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.security,
                        color: theme.secondaryColor,
                      ),
                      title: Text(
                        'Seguridad',
                        style: GoogleFonts.nunitoSans(
                          color: theme.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.hintTextColor,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.errorColor.withOpacity(0.2),
                  foregroundColor: theme.errorColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text(
                      'Cerrar sesión',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(
    BuildContext context,
    ThemeProvider theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.secondaryColor, size: 24),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: theme.hintTextColor,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
  Widget _buildStatItem(ThemeProvider theme, {required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.nunitoSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.secondaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            color: theme.hintTextColor,
          ),
        ),
      ],
    );
  }
  */
}
