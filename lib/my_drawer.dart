// my_drawer.dart
import 'package:flutter/material.dart';
import 'package:app_uts/about_page.dart';
import 'package:app_uts/help_page.dart';
import 'package:app_uts/home_page.dart';
import 'package:app_uts/result_page.dart';
import 'package:app_uts/settings_page.dart';
import 'package:app_uts/transaksi_model.dart';
import 'package:app_uts/profile_page.dart';

class MyDrawer extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;

  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const MyDrawer({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.dataList,
    required this.navigateToForm,
    required this.deleteTransaksi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(
              'Menu Navigasi',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 24,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    currentThemeMode: currentThemeMode,
                    onThemeChanged: onThemeChanged,
                    dataList: dataList,
                    navigateToForm: navigateToForm,
                    deleteTransaksi: deleteTransaksi,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage( // <-- Sekarang ini akan dikenali
                    currentThemeMode: currentThemeMode,
                    onThemeChanged: onThemeChanged,
                    dataList: dataList,
                    navigateToForm: navigateToForm,
                    deleteTransaksi: deleteTransaksi,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Semua Transaksi'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    currentThemeMode: currentThemeMode,
                    onThemeChanged: onThemeChanged,
                    dataList: dataList,
                    navigateToForm: navigateToForm,
                    deleteTransaksi: deleteTransaksi,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(
                    currentThemeMode: currentThemeMode,
                    onThemeChanged: onThemeChanged,
                    dataList: dataList,
                    navigateToForm: navigateToForm,
                    deleteTransaksi: deleteTransaksi,
                  ),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    currentThemeMode: currentThemeMode,
                    onThemeChanged: onThemeChanged,
                    dataList: dataList,
                    navigateToForm: navigateToForm,
                    deleteTransaksi: deleteTransaksi,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Bantuan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(
                    currentThemeMode: currentThemeMode,
                    onThemeChanged: onThemeChanged,
                    dataList: dataList,
                    navigateToForm: navigateToForm,
                    deleteTransaksi: deleteTransaksi,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}