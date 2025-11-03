// settings_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:app_uts/transaksi_model.dart';

// 1. Ubah menjadi StatefulWidget
class SettingsPage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;
  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const SettingsPage({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.dataList,
    required this.navigateToForm,
    required this.deleteTransaksi,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 2. Buat state lokal untuk mengontrol switch
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    // 3. Set nilai awal switch berdasarkan data yang diterima
    _isDarkMode = widget.currentThemeMode == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      drawer: MyDrawer(
        currentThemeMode: widget.currentThemeMode,
        onThemeChanged: widget.onThemeChanged,
        dataList: widget.dataList,
        navigateToForm: widget.navigateToForm,
        deleteTransaksi: widget.deleteTransaksi,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Aktifkan untuk tampilan gelap'),

              // 4. Gunakan state lokal
              value: _isDarkMode,

              onChanged: (bool isDark) {
                // 5. Panggil fungsi utama di main.dart (untuk simpan ke Hive)
                widget.onThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light);

                // 6. Update UI switch ini secara instan
                setState(() {
                  _isDarkMode = isDark;
                });
              },
              secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
          ],
        ),
      ),
    );
  }
}