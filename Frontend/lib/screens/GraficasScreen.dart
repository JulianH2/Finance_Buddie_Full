import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_buddie/provider/ThemeProvider.dart';
import 'package:finance_buddie/provider/FinanzasProvider.dart';

class GraficasScreen extends StatefulWidget {
  const GraficasScreen({super.key});

  @override
  State<GraficasScreen> createState() => _GraficasScreenState();
}

class _GraficasScreenState extends State<GraficasScreen> {
  double totalIngresos = 0;
  double totalGastos = 0;
  bool isLoading = true;
  double cambioIngresos = 0.0;
  double cambioGastos = 0.0;

  Map<String, double> ingresosPorMes = {};
  Map<String, double> gastosPorMes = {};
  Map<String, double> desgloseIngresos = {};
  Map<String, double> desgloseGastos = {};

  @override
  void initState() {
    super.initState();
    cargarTotales();
  }

  Future<void> cargarTotales() async {
    final finanzasProvider = Provider.of<FinanzasProvider>(
      context,
      listen: false,
    );
    final ingresos = await finanzasProvider.obtenerTotalIngresos();
    final gastos = await finanzasProvider.obtenerTotalGastos();
    final ingresosMes = await finanzasProvider.obtenerIngresosPorMes();
    final gastosMes = await finanzasProvider.obtenerGastosPorMes();
    final ingresoPorCategoria =
        await finanzasProvider.obtenerGastosPorCategoria();
    final gastoPorCategoria =
        await finanzasProvider.obtenerGastosPorCategoria();
    final ingresoCambio = calcularPorcentajeCambio(
      ingresosPorMes.values.toList(),
    );
    final gastoCambio = calcularPorcentajeCambio(gastosPorMes.values.toList());

    setState(() {
      totalIngresos = ingresos;
      totalGastos = gastos;
      ingresosPorMes = ingresosMes;
      gastosPorMes = gastosMes;
      desgloseIngresos = ingresoPorCategoria;
      desgloseGastos = gastoPorCategoria;
      cambioIngresos = ingresoCambio;
      cambioGastos = gastoCambio;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.backgroundColor,
        appBar: AppBar(
          title: const Text('Gráficas'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Ingresos',
                  style: TextStyle(color: colors.textColor),
                ),
              ),
              Tab(
                child: Text(
                  'Egresos',
                  style: TextStyle(color: colors.textColor),
                ),
              ),
            ],
            indicatorColor: colors.primaryColor,
            labelColor: colors.primaryColor,
            unselectedLabelColor: colors.hintTextColor,
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  children: [
                    _buildIncomeTab(colors),
                    _buildExpensesTab(colors),
                  ],
                ),
      ),
    );
  }

  Widget _buildIncomeTab(ThemeProvider colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildGraphHeader(
            colors: colors,
            title: 'INGRESOS',
            amount: '+ \$${totalIngresos.toStringAsFixed(2)}',
            percentage: '${cambioIngresos.toStringAsFixed(1)}%',
          ),
          const SizedBox(height: 24),
          _buildBarChart(colors, ingresosPorMes.values.toList()),
          const SizedBox(height: 16),
          _buildMonthLegend(ingresosPorMes.keys.toList()),
          const SizedBox(height: 24),
          _buildIncomeBreakdown(colors),
        ],
      ),
    );
  }

  Widget _buildExpensesTab(ThemeProvider colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildGraphHeader(
            colors: colors,
            title: 'EGRESOS',
            amount: '- \$${totalGastos.toStringAsFixed(2)}',
            percentage: '${cambioGastos.toStringAsFixed(1)}%',
          ),
          const SizedBox(height: 24),
          _buildBarChart(colors, gastosPorMes.values.toList(), isExpense: true),
          const SizedBox(height: 16),
          _buildMonthLegend(gastosPorMes.keys.toList()),
          const SizedBox(height: 24),
          _buildExpensesBreakdown(colors),
        ],
      ),
    );
  }

  Widget _buildGraphHeader({
    required ThemeProvider colors,
    required String title,
    required String amount,
    required String percentage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: colors.hintTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    title == 'INGRESOS'
                        ? colors.successColor
                        : colors.errorColor,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            percentage,
            style: TextStyle(
              color: colors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(
    ThemeProvider colors,
    List<double> values, {
    bool isExpense = false,
  }) {
    if (values.isEmpty) {
      return Center(
        child: Text(
          'No hay registros aún',
          style: TextStyle(
            color: colors.hintTextColor,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final color = isExpense ? colors.errorColor : colors.successColor;

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            values.map((value) {
              final height = (value / maxValue) * 150;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 30,
                    height: height,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMonthLegend(List<String> meses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: meses.map((mes) => Text(mes)).toList(),
    );
  }

  Widget _buildIncomeBreakdown(ThemeProvider colors) {
    return _buildBreakdownList(
      colors,
      'Desglose de Ingresos',
      desgloseIngresos,
      totalIngresos,
      baseColor: colors.successColor,
    );
  }

  Widget _buildExpensesBreakdown(ThemeProvider colors) {
    return _buildBreakdownList(
      colors,
      'Desglose de Egresos',
      desgloseGastos,
      totalGastos,
      baseColor: colors.errorColor,
    );
  }

  Widget _buildBreakdownList(
    ThemeProvider colors,
    String title,
    Map<String, double> data,
    double total, {
    required Color baseColor,
  }) {
    final keys = data.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(keys.length, (index) {
          final categoria = keys[index];
          final monto = data[categoria]!;
          final porcentaje = total > 0 ? (monto / total * 100) : 0;
          return _buildBreakdownItem(
            colors: colors,
            label: categoria,
            percentage: '${porcentaje.toStringAsFixed(1)}%',
            color: baseColor.withOpacity(1 - (index * 0.2)),
          );
        }),
      ],
    );
  }

  double calcularPorcentajeCambio(List<double> valores) {
    if (valores.length < 2) return 0;
    final actual = valores[valores.length - 1];
    final anterior = valores[valores.length - 2];
    if (anterior == 0) return 0;
    return ((actual - anterior) / anterior) * 100;
  }

  Widget _buildBreakdownItem({
    required ThemeProvider colors,
    required String label,
    required String percentage,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: colors.textColor)),
          ),
          Text(
            percentage,
            style: TextStyle(
              color: colors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
