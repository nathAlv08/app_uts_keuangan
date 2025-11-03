// home_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:app_uts/transaksi_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;
  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const HomePage({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.dataList,
    required this.navigateToForm,
    required this.deleteTransaksi,
  }) : super(key: key);

  double _hitungTotalByTipe(TipeTransaksi tipe) {
    double total = 0;
    for (var transaksi in dataList) {
      if (transaksi.tipe == tipe) {
        total += transaksi.jumlah;
      }
    }
    return total;
  }

  String _formatRupiah(int angka) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(angka);
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context, Transaksi transaksi) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus "${transaksi.keterangan}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final totalPemasukan = _hitungTotalByTipe(TipeTransaksi.pemasukan);
    final totalPengeluaran = _hitungTotalByTipe(TipeTransaksi.pengeluaran);
    final bool dataKosong = dataList.isEmpty;
    final reversedList = dataList.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Home'),
      ),
      drawer: MyDrawer(
        currentThemeMode: currentThemeMode,
        onThemeChanged: onThemeChanged,
        dataList: dataList,
        navigateToForm: navigateToForm,
        deleteTransaksi: deleteTransaksi,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selamat Datang!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Ringkasan Keuangan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 35),
              SizedBox(
                height: 200,
                child: dataKosong
                    ? Center(
                  child: Text(
                    'Belum ada data grafik.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
                    : PieChart(
                  // --- PERBAIKAN DI SINI ---
                  // Parameter animasi dipindahkan ke sini
                  swapAnimationDuration: const Duration(milliseconds: 750),
                  swapAnimationCurve: Curves.easeInOut,

                  PieChartData(
                    // Parameter animasi Dihapus dari sini
                    sections: [
                      PieChartSectionData(
                        value: totalPemasukan,
                        color: Colors.green.shade400,
                        radius: 80,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: totalPengeluaran,
                        color: Colors.red.shade400,
                        radius: 80,
                        showTitle: false,
                      ),
                    ],
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (!dataKosong)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(Colors.green.shade400, 'Pemasukan'),
                      const SizedBox(width: 24),
                      _buildLegendItem(Colors.red.shade400, 'Pengeluaran'),
                    ],
                  ),
                ),
              const Divider(height: 30),
              Text(
                'Transaksi Terakhir',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              dataKosong
                  ? Text(
                'Belum ada transaksi.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reversedList.length,
                itemBuilder: (context, index) {
                  final item = reversedList[index];
                  bool isPemasukan = item.tipe == TipeTransaksi.pemasukan;

                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,

                    confirmDismiss: (direction) async {
                      final bool? res = await _showDeleteDialog(context, item);
                      return res ?? false;
                    },

                    onDismissed: (direction) {
                      deleteTransaksi(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${item.keterangan}" telah dihapus.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },

                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: Icon(
                          isPemasukan ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isPemasukan ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          item.keterangan,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          item.tanggal != null
                              ? DateFormat('d MMM yyyy, HH:mm').format(item.tanggal!)
                              : 'Tanpa tanggal',
                        ),
                        trailing: Text(
                          '${isPemasukan ? '+' : '-'} ${_formatRupiah(item.jumlah)}',
                          style: TextStyle(
                            color: isPemasukan ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          navigateToForm(context, transaksiToEdit: item);
                        },
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToForm(context),
        tooltip: 'Tambah Transaksi',
        child: const Icon(Icons.add),
      ),
    );
  }
}