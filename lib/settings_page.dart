// settings_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:app_uts/transaksi_model.dart';

class SettingsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool isDarkMode = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      drawer: MyDrawer(
        currentThemeMode: currentThemeMode,
        onThemeChanged: onThemeChanged,
        dataList: dataList,
        navigateToForm: navigateToForm,
        deleteTransaksi: deleteTransaksi,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Aktifkan untuk tampilan gelap'),
              value: isDarkMode,
              onChanged: (bool isDark) {
                onThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light);
              },
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
          ],
        ),
      ),
    );
  }
}