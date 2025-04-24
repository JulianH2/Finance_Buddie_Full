import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/ThemeProvider.dart';
import 'LoginScreen.dart';
import 'ProfileScreen.dart'; // Asegúrate de importar tu pantalla de perfil

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.textColor),
        ),
        elevation: 0,
        backgroundColor: theme.surfaceColor,
        iconTheme: IconThemeData(color: theme.appBarIconColor),
      ),
      body: Column(
        children: [
          _buildProfileHeader(context, theme),
          Expanded(child: _buildMenuOptions(context, theme)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeProvider theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        color: theme.surfaceColor,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.secondaryColor.withOpacity(0.2),
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/41.jpg',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Juan Pérez', // Nombre de ejemplo
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ver tu perfil', // Texto secundario
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
    );
  }

  Widget _buildMenuOptions(BuildContext context, ThemeProvider theme) {
    final List<Map<String, dynamic>> opciones = [
      {
        "icon": Icons.settings,
        "title": "Configuración",
        "action": () => _showSettingsModal(context, theme),
      },
      {
        "icon": Icons.help_outline,
        "title": "Ayuda y Soporte",
        "action": () => _showHelpModal(context, theme),
      },
      {
        "icon": Icons.info_outline,
        "title": "Acerca de",
        "action": () => _showAboutModal(context, theme),
      },
      {
        "icon": Icons.exit_to_app,
        "title": "Cerrar sesión",
        "action":
            () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            ),
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: opciones.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: theme.cardColor,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: Icon(
              opciones[index]["icon"],
              color: theme.secondaryColor,
              size: 28,
            ),
            title: Text(
              opciones[index]["title"],
              style: GoogleFonts.nunitoSans(
                color: theme.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: theme.hintTextColor),
            onTap: opciones[index]["action"],
          ),
        );
      },
    );
  }

  // Los métodos _showSettingsModal, _showHelpModal y _showAboutModal permanecen iguales
  void _showSettingsModal(BuildContext context, ThemeProvider theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configuración',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modo Oscuro',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      color: theme.textColor,
                    ),
                  ),
                  Switch(
                    value: theme.isDarkMode,
                    onChanged: (value) => theme.toggleTheme(value),
                    activeColor: theme.secondaryColor,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Notificaciones',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  color: theme.textColor,
                ),
              ),
              SizedBox(height: 8),
              SwitchListTile(
                title: Text(
                  'Recordatorios de pago',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: theme.hintTextColor,
                  ),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: theme.secondaryColor,
              ),
              SwitchListTile(
                title: Text(
                  'Nuevos mensajes',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: theme.hintTextColor,
                  ),
                ),
                value: false,
                onChanged: (value) {},
                activeColor: theme.secondaryColor,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'GUARDAR CONFIGURACIÓN',
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showHelpModal(BuildContext context, ThemeProvider theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ayuda y Soporte',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
              SizedBox(height: 16),
              _buildHelpItem(
                theme,
                icon: Icons.phone,
                title: 'Llámanos',
                subtitle: '+1 234 567 890',
              ),
              _buildHelpItem(
                theme,
                icon: Icons.email,
                title: 'Correo electrónico',
                subtitle: 'soporte@rentify.com',
              ),
              _buildHelpItem(
                theme,
                icon: Icons.chat_bubble,
                title: 'Chat en vivo',
                subtitle: 'Disponible 24/7',
              ),
              SizedBox(height: 24),
              Text(
                'Preguntas frecuentes',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• ¿Cómo renovar mi contrato?\n'
                '• ¿Qué hacer en caso de incidencia?\n'
                '• ¿Cómo realizar un pago?',
                style: GoogleFonts.nunitoSans(color: theme.hintTextColor),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpItem(
    ThemeProvider theme, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.secondaryColor),
      title: Text(
        title,
        style: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w600,
          color: theme.textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.nunitoSans(color: theme.hintTextColor),
      ),
      onTap: () {},
    );
  }

  void _showAboutModal(BuildContext context, ThemeProvider theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.secondaryColor.withOpacity(0.2),
                child: Icon(
                  Icons.apartment,
                  size: 40,
                  color: theme.secondaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Rentify App',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: theme.textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Versión 2.1.0',
                style: GoogleFonts.nunitoSans(color: theme.hintTextColor),
              ),
              SizedBox(height: 24),
              Text(
                'La mejor solución para gestionar tus propiedades y arriendos',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(color: theme.textColor),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                '© 2023 Rentify. Todos los derechos reservados.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: theme.hintTextColor,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
