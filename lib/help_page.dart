// help_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:app_uts/transaksi_model.dart';

class HelpPage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;

  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const HelpPage({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.dataList,
    required this.navigateToForm,
    required this.deleteTransaksi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
      ),
      drawer: MyDrawer(
        currentThemeMode: currentThemeMode,
        onThemeChanged: onThemeChanged,
        dataList: dataList,
        navigateToForm: navigateToForm,
        deleteTransaksi: deleteTransaksi,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Frequently Asked Questions (FAQ)',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ExpansionTile(
            leading: Icon(Icons.question_answer),
            title: Text('Bagaimana cara menambah data?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    '1. Tekan tombol tambah (+) di pojok kanan bawah Halaman Home atau Halaman Daftar Transaksi.\n'
                        '2. Isi form lalu tekan "Simpan Transaksi".'),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.edit),
            title: Text('Bagaimana cara mengedit/menghapus data?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    '1. Untuk mengedit: Klik pada data transaksi yang ingin diubah.\n'
                        '2. Untuk menghapus: Geser data transaksi ke kiri, lalu tekan "Hapus" saat konfirmasi muncul.'),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.palette),
            title: Text('Bagaimana cara mengubah tema?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    '1. Buka menu navigasi (pojok kiri atas).\n'
                        '2. Pilih "Pengaturan".\n'
                        '3. Aktifkan/non-aktifkan "Mode Gelap".'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}