import 'package:finance_buddie/provider/ThemeProvider.dart';
import 'package:finance_buddie/provider/TransaccionesProvider.dart';
import 'package:finance_buddie/screens/AllTransactionsScreen.dart';
import 'package:finance_buddie/screens/GraficasScreen.dart';
import 'package:finance_buddie/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_buddie/model/transaccion.dart';

class TransaccionesScreen extends StatelessWidget {
  const TransaccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider;
    final transaccionesProvider = Provider.of<TransaccionesProvider>(context);
    const idUsuario = 2;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance total con datos dinámicos
            FutureBuilder<Map<String, dynamic>>(
              future: transaccionesProvider.obtenerGastosPorMes(idUsuario),
              builder: (context, snapshot) {
                final balance = snapshot.data?['total'] as double? ?? 0.0;
                return _buildBalanceHeader(colors, balance);
              },
            ),
            const SizedBox(height: 24),

            // Gráfica interactiva
            _buildGraphSection(context, colors),
            const SizedBox(height: 24),

            // Filtros y encabezado de transacciones
            _buildTransactionsHeader(context, colors),
            const SizedBox(height: 8),

            // Lista de transacciones recientes dinámicas
            FutureBuilder<List<Transaccion>>(
              future: transaccionesProvider.obtenerTransaccionesRecientes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colors.primaryColor,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay transacciones recientes',
                      style: TextStyle(color: colors.hintTextColor),
                    ),
                  );
                }
                return _buildTransactionList(colors, snapshot.data!);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionModal(context),
        backgroundColor: colors.secondaryColor,
        child: Icon(Icons.add, color: colors.buttonTextColor),
      ),
    );
  }

  Widget _buildBalanceHeader(ThemeProvider colors, double balance) {
    return Card(
      color: colors.surfaceColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BALANCE TOTAL',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.hintTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButton<String>(
                  items: const [
                    DropdownMenuItem(
                      value: 'Último mes',
                      child: Text('Último mes'),
                    ),
                    DropdownMenuItem(
                      value: 'Últimos 3 meses',
                      child: Text('Últimos 3 meses'),
                    ),
                    DropdownMenuItem(
                      value: 'Este año',
                      child: Text('Este año'),
                    ),
                  ],
                  onChanged: (_) {},
                  underline: Container(),
                  icon: Icon(Icons.filter_list, color: colors.hintTextColor),
                  hint: Text(
                    'Filtrar',
                    style: TextStyle(fontSize: 14, color: colors.hintTextColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphSection(BuildContext context, ThemeProvider colors) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GraficasScreen()),
        );
      },
      child: Card(
        color: colors.surfaceColor,
        elevation: 1,
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
                    'RESUMEN',
                    style: TextStyle(
                      color: colors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Ver gráficas',
                        style: TextStyle(color: colors.primaryColor),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: colors.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colors.cardColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        color: colors.hintTextColor,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para ver gráficos completos',
                        style: TextStyle(color: colors.hintTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsHeader(BuildContext context, ThemeProvider colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TRANSACCIONES RECIENTES',
            style: TextStyle(
              fontSize: 16,
              color: colors.hintTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllTransactionsScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: colors.secondaryColor),
            child: const Text('Ver todas'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    ThemeProvider colors,
    List<Transaccion> transactions,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        final isIncome = t.tipo == 'Ingreso';
        final icon = _getIconForCategory(t.categoria, isIncome);
        final date = _formatDate(t.fechaOperacion);
        final amountStr =
            '${isIncome ? '+' : '-'}\$${t.monto.toStringAsFixed(2)}';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: colors.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        isIncome
                            ? colors.successColor.withOpacity(0.2)
                            : colors.errorColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isIncome ? colors.successColor : colors.errorColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.categoria.capitalize(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.hintTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  amountStr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? colors.successColor : colors.errorColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    // final colors = Provider.of<ThemeProvider>(context, listen: false);
    // final finanzasProvider = context.read<FinanzasProvider>();
    final _formKey = GlobalKey<FormState>();
    final montoCtrl = TextEditingController();
    String tipo = 'Gasto';
    String categoria = 'comida';
    DateTime fecha = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva Transacción',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: montoCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monto'),
                        validator:
                            (v) =>
                                (v == null || v.isEmpty)
                                    ? 'Ingrese monto'
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: tipo,
                        items: const [
                          DropdownMenuItem(
                            value: 'Ingreso',
                            child: Text('Ingreso'),
                          ),
                          DropdownMenuItem(
                            value: 'Gasto',
                            child: Text('Gasto'),
                          ),
                        ],
                        onChanged: (v) => tipo = v!,
                        decoration: const InputDecoration(labelText: 'Tipo'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: categoria,
                        items: const [
                          DropdownMenuItem(
                            value: 'comida',
                            child: Text('Comida'),
                          ),
                          DropdownMenuItem(
                            value: 'compras',
                            child: Text('Compras'),
                          ),
                          DropdownMenuItem(
                            value: 'entretenimiento',
                            child: Text('Entretenimiento'),
                          ),
                          DropdownMenuItem(
                            value: 'transporte',
                            child: Text('Transporte'),
                          ),
                          DropdownMenuItem(
                            value: 'servicios',
                            child: Text('Servicios'),
                          ),
                          DropdownMenuItem(
                            value: 'salud',
                            child: Text('Salud'),
                          ),
                          DropdownMenuItem(
                            value: 'educación',
                            child: Text('Educación'),
                          ),
                        ],
                        onChanged: (v) => categoria = v!,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fecha,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) fecha = picked;
                        },
                        child: Text('Fecha: ${_formatDate(fecha)}'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            //  final monto = double.parse(montoCtrl.text);

                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: const Center(child: Text('Guardar')),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  String _formatDate(DateTime date) {
    const meses = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${meses[date.month - 1]} ${date.year}';
  }
}

IconData _getIconForCategory(String category, bool isIncome) {
  if (isIncome) return Icons.account_balance_wallet_outlined;
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
