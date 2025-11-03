// about_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:app_uts/transaksi_model.dart';

class AboutPage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;

  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const AboutPage({
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
        title: const Text('Tentang Aplikasi'),
      ),
      drawer: MyDrawer(
        currentThemeMode: currentThemeMode,
        onThemeChanged: onThemeChanged,
        dataList: dataList,
        navigateToForm: navigateToForm,
        deleteTransaksi: deleteTransaksi,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.code,
                  size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 20),
              const Text(
                'Aplikasi Pencatat Keuangan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aplikasi ini dibuat untuk memenuhi Ujian Tengah Semester mata kuliah Pemrograman Mobile.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Terima kasih telah menggunakan aplikasi ini!',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}