import 'package:finance_buddie/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_buddie/provider/FinanzasProvider.dart';
import 'package:finance_buddie/provider/ThemeProvider.dart';
import 'package:finance_buddie/Model/Transaccion.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  _AllTransactionsScreenState createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  String? _selectedCategory;

  final List<String> categoriasFijas = [
    'Comida',
    'Compras',
    'Entretenimiento',
    'Transporte',
    'Servicios',
    'Salud',
    'Educación',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ThemeProvider>(context);
    final finanzas = Provider.of<FinanzasProvider>(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        title: const Text('Todas las Transacciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: colors.appBarColor,
        foregroundColor: colors.textColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Filtrar por categoría',
                filled: true,
                fillColor: colors.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items:
                  [null, ...categoriasFijas].map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat ?? 'Todas'),
                    );
                  }).toList(),
              onChanged: (val) {
                setState(() => _selectedCategory = val);
              },
            ),
          ),

          // Lista completa
          Expanded(
            child: FutureBuilder<List<Transaccion>>(
              future: finanzas.obtenerTransacciones(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colors.primaryColor,
                    ),
                  );
                }
                final all = snapshot.data ?? [];
                final filtered =
                    _selectedCategory == null
                        ? all
                        : all
                            .where(
                              (t) =>
                                  t.categoria.toLowerCase() ==
                                  _selectedCategory!.toLowerCase(),
                            )
                            .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: colors.hintTextColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedCategory == null
                              ? 'No hay transacciones registradas.'
                              : 'No hay registros aún de esta categoría.',
                          style: TextStyle(
                            color: colors.hintTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final t = filtered[i];
                    final isIncome = t.tipo == 'Ingreso';
                    final icon = _getIconForCategory(t.categoria, isIncome);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: colors.surfaceColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isIncome
                                  ? colors.successColor.withOpacity(0.2)
                                  : colors.errorColor.withOpacity(0.2),
                          child: Icon(
                            icon,
                            color:
                                isIncome
                                    ? colors.successColor
                                    : colors.errorColor,
                          ),
                        ),
                        title: Text(
                          t.categoria.capitalize(),
                          style: TextStyle(color: colors.textColor),
                        ),
                        subtitle: Text(
                          _formatDate(t.fechaOperacion),
                          style: TextStyle(color: colors.hintTextColor),
                        ),
                        trailing: Text(
                          '${isIncome ? '+' : '-'}\$${t.monto.toStringAsFixed(2)}',
                          style: TextStyle(
                            color:
                                isIncome
                                    ? colors.successColor
                                    : colors.errorColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final meses = [
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
}
