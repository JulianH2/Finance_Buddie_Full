import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_buddie/provider/ThemeProvider.dart';

class OrganizadorScreen extends StatelessWidget {
  const OrganizadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance total
            _buildTotalBalance(colors),
            const SizedBox(height: 24),

            // Sección de gastos mensuales
            _buildMonthlyExpenses(colors),
            const SizedBox(height: 16),

            // Sección de metas
            _buildGoalsSection(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalance(ThemeProvider colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOTAL BALANCE',
          style: TextStyle(
            fontSize: 14,
            color: colors.hintTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$5,750',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyExpenses(ThemeProvider colors) {
    return Card(
      elevation: 0,
      color: colors.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GASTOS MENSUALES',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '-\$1000',
                    style: TextStyle(
                      color: colors.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  colors,
                  icon: Icons.settings,
                  label: 'GESTIONAR',
                  color: colors.primaryColor,
                ),
                _buildActionButton(
                  colors,
                  icon: Icons.calendar_today,
                  label: 'PLANIFICACIÓN',
                  color: colors.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    ThemeProvider colors, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 20, color: color),
          label: Text(label, style: TextStyle(color: color)),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSection(ThemeProvider colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'METAS DE AHORRO',
          style: TextStyle(
            fontSize: 16,
            color: colors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildGoalItem(
          colors,
          title: 'VIAJE VERACRUZ',
          amount: '500',
          time: '2 MESES',
          progress: 0.65,
        ),
        const SizedBox(height: 8),
        _buildGoalItem(
          colors,
          title: 'SUBASTA MOTO',
          amount: '200/mes',
          time: '6 MESES',
          progress: 0.3,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'VER MÁS',
              style: TextStyle(
                color: colors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalItem(
    ThemeProvider colors, {
    required String title,
    required String amount,
    required String time,
    required double progress,
  }) {
    return Card(
      elevation: 0,
      color: colors.surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: colors.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(time, style: TextStyle(color: colors.hintTextColor)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colors.dividerColor,
              color: colors.successColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
