import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ThemeProvider.dart';
import '../provider/TransaccionesProvider.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider;
    final transaccionesProvider = Provider.of<TransaccionesProvider>(context);
    final idUsuario = 1;
    //final size = MediaQuery.of(context).size;

    transaccionesProvider.cargarTransacciones(idUsuario);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(
                  colors,
                  balance: _calcularBalanceTotal(
                    transaccionesProvider.transacciones,
                  ),
                  porcentaje: _calcularPorcentajeCambio(
                    transaccionesProvider.transacciones,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSummaryCards(
                  colors,
                  ingresos: _calcularTotalIngresos(
                    transaccionesProvider.transacciones,
                  ),
                  gastos: _calcularTotalGastos(
                    transaccionesProvider.transacciones,
                  ),
                ),
                const SizedBox(height: 32),

                _buildTransactionsHeader(context, colors),
                const SizedBox(height: 16),

                _buildTransactionListContainer(
                  context,
                  colors,
                  transaccionesProvider,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calcularBalanceTotal(List<dynamic> transacciones) {
    double balance = 0.0;
    for (var transaccion in transacciones) {
      if (transaccion['tipo'] == 'ingreso') {
        balance += transaccion['monto'];
      } else {
        balance -= transaccion['monto'];
      }
    }
    return balance;
  }

  double _calcularPorcentajeCambio(List<dynamic> transacciones) {
    return 12.0;
  }

  double _calcularTotalIngresos(List<dynamic> transacciones) {
    return transacciones
        .where((t) => t['tipo'] == 'Ingreso')
        .fold(0.0, (sum, t) => sum + t['monto']);
  }

  double _calcularTotalGastos(List<dynamic> transacciones) {
    return transacciones
        .where((t) => t['tipo'] == 'gasto')
        .fold(0.0, (sum, t) => sum + t['monto']);
  }

  Widget _buildTransactionListContainer(
    BuildContext context,
    ThemeProvider colors,
    TransaccionesProvider provider,
  ) {
    final height = MediaQuery.of(context).size.height * 0.42;

    if (provider.isLoading) {
      return SizedBox(
        height: height,
        child: Center(
          child: CircularProgressIndicator(
            color: colors.primaryColor,
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (provider.errorMessage != null) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            provider.errorMessage!,
            style: TextStyle(color: colors.errorColor, fontSize: 16),
          ),
        ),
      );
    }

    if (provider.transacciones.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: colors.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No hay transacciones recientes',
                style: TextStyle(
                  color: colors.hintTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Ordenar transacciones por fecha (más recientes primero)
    final transaccionesOrdenadas = List.from(provider.transacciones)
      ..sort((a, b) => b['fecha'].compareTo(a['fecha']));

    // Tomar solo las últimas 5 transacciones
    final transaccionesRecientes = transaccionesOrdenadas.take(5).toList();

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: transaccionesRecientes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final transaccion = transaccionesRecientes[index];
          return _buildTransactionItem(
            colors: colors,
            transaccion: transaccion,
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(
    ThemeProvider colors, {
    required double balance,
    required double porcentaje,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryColor, colors.primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance Total',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(
                      porcentaje >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 20,
                      color:
                          porcentaje >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${porcentaje.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color:
                            porcentaje >= 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    ThemeProvider colors, {
    required double ingresos,
    required double gastos,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            colors: colors,
            title: 'Ingresos',
            amount: ingresos,
            icon: Icons.arrow_downward_rounded,
            isIncome: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            colors: colors,
            title: 'Gastos',
            amount: gastos,
            icon: Icons.arrow_upward_rounded,
            isIncome: false,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required ThemeProvider colors,
    required String title,
    required double amount,
    required IconData icon,
    required bool isIncome,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isIncome
                          ? colors.successColor.withOpacity(0.15)
                          : colors.errorColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isIncome ? colors.successColor : colors.errorColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors.hintTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context, ThemeProvider colors) {
    return Row(
      children: [
        Text(
          'Transacciones Recientes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: colors.secondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Ver más',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required ThemeProvider colors,
    required Map<String, dynamic> transaccion,
  }) {
    final isIncome = transaccion['tipo'] == 'ingreso';
    final icon = _getIconForCategory(transaccion['categoria'], isIncome);
    final fecha = DateTime.parse(transaccion['fecha']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isIncome
                      ? colors.successColor.withOpacity(0.15)
                      : colors.errorColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isIncome ? colors.successColor : colors.errorColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaccion['categoria'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(fecha),
                  style: TextStyle(fontSize: 14, color: colors.hintTextColor),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${transaccion['monto'].toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isIncome ? colors.successColor : colors.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${date.day} ${monthNames[date.month - 1]} ${date.year}';
  }

  IconData _getIconForCategory(String category, bool isIncome) {
    if (isIncome) {
      return Icons.account_balance_wallet_outlined;
    }

    switch (category.toLowerCase()) {
      case 'comida':
        return Icons.restaurant_outlined;
      case 'compras':
        return Icons.shopping_bag_outlined;
      case 'entretenimiento':
        return Icons.movie_outlined;
      case 'transporte':
        return Icons.directions_car_outlined;
      case 'servicios':
        return Icons.receipt_outlined;
      case 'salud':
        return Icons.medical_services_outlined;
      case 'educación':
        return Icons.school_outlined;
      default:
        return Icons.money_off_outlined;
    }
  }
}
