// result_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:intl/intl.dart';
import 'package:app_uts/transaksi_model.dart';

class ResultPage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;
  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const ResultPage({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.dataList,
    required this.navigateToForm,
    required this.deleteTransaksi,
  }) : super(key: key);

  int _hitungTotalSaldo() {
    int total = 0;
    for (var transaksi in dataList) {
      if (transaksi.tipe == TipeTransaksi.pemasukan) {
        total += transaksi.jumlah;
      } else {
        total -= transaksi.jumlah;
      }
    }
    return total;
  }

  String _formatRupiah(int angka) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(angka);
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
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    int totalSaldo = _hitungTotalSaldo();
    final reversedList = dataList.reversed.toList();
    bool isGelap = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Transaksi'),
      ),
      drawer: MyDrawer(
        currentThemeMode: currentThemeMode,
        onThemeChanged: onThemeChanged,
        dataList: dataList,
        navigateToForm: navigateToForm,
        deleteTransaksi: deleteTransaksi,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isGelap
                    ? [Colors.indigo.shade700, Colors.indigo.shade400]
                    : [Colors.indigo.shade400, Colors.indigo.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Saldo',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.5),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    _formatRupiah(totalSaldo),
                    key: ValueKey<int>(totalSaldo),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: totalSaldo < 0 ? Colors.red.shade200 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: dataList.isEmpty
                ? const Center(
              child: Text(
                'Belum ada transaksi.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: reversedList.length,
              itemBuilder: (context, index) {
                final item = reversedList[index];
                bool isPemasukan = item.tipe == TipeTransaksi.pemasukan;

                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.endToStart,

                  confirmDismiss: (direction) async {
                    final bool? res = await _showDeleteDialog(context, item);
                    if (res == true) {
                      deleteTransaksi(item.id);
                    }
                    return res;
                  },

                  onDismissed: (direction) {
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
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToForm(context),
        tooltip: 'Tambah Transaksi',
        child: const Icon(Icons.add),
      ),
    );
  }
}