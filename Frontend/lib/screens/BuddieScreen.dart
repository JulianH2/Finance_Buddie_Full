import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/ThemeProvider.dart';

class BuddieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Mi Buddie',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.textColor),
        ),
        elevation: 0,
        backgroundColor: theme.surfaceColor,
        iconTheme: IconThemeData(color: theme.appBarIconColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/buddie_icon.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Buddie',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor,
                    ),
                  ),
                  Text(
                    'Nivel 5',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      color: theme.hintTextColor,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: theme.cardColor,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Medallas',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textColor,
                            ),
                          ),
                          Text(
                            '3/10',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              color: theme.hintTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMedal(
                            theme,
                            icon: Icons.star,
                            color: Colors.amber,
                            earned: true,
                          ),
                          _buildMedal(
                            theme,
                            icon: Icons.favorite,
                            color: Colors.red,
                            earned: true,
                          ),
                          _buildMedal(
                            theme,
                            icon: Icons.bolt,
                            color: Colors.blue,
                            earned: true,
                          ),
                          _buildMedal(
                            theme,
                            icon: Icons.eco,
                            color: Colors.green,
                            earned: false,
                          ),
                          _buildMedal(
                            theme,
                            icon: Icons.diamond,
                            color: Colors.purple,
                            earned: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tienda de Accesorios',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Personaliza a tu Buddie',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          color: theme.hintTextColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildAccessoryItem(
                              theme,
                              'Gafas',
                              Icons.emoji_people,
                              50,
                            ),
                            _buildAccessoryItem(
                              theme,
                              'Sombrero',
                              Icons.emoji_objects,
                              75,
                            ),
                            _buildAccessoryItem(
                              theme,
                              'Corbatín',
                              Icons.emoji_emotions,
                              30,
                            ),
                            _buildAccessoryItem(
                              theme,
                              'Bufanda',
                              Icons.emoji_nature,
                              60,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.secondaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Comprar Monedas',
                            style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedal(
    ThemeProvider theme, {
    required IconData icon,
    required Color color,
    required bool earned,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 36,
          color: earned ? color : theme.hintTextColor.withOpacity(0.3),
        ),
        SizedBox(height: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: earned ? color : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildAccessoryItem(
    ThemeProvider theme,
    String name,
    IconData icon,
    int price,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Icon(icon, size: 40, color: theme.secondaryColor),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.nunitoSans(fontSize: 14, color: theme.textColor),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.monetization_on, size: 16, color: Colors.amber),
              SizedBox(width: 4),
              Text(
                price.toString(),
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: theme.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.secondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Equipar',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
