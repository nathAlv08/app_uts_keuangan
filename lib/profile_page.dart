// profile_page.dart
import 'package:flutter/material.dart';
import 'package:app_uts/my_drawer.dart';
import 'package:app_uts/transaksi_model.dart';

class ProfilePage extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final List<Transaksi> dataList;

  final Function(BuildContext, {Transaksi? transaksiToEdit}) navigateToForm;
  final Function(String) deleteTransaksi;

  const ProfilePage({
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
        title: const Text('Profil Pengguna'),
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
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Icon(Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Udin Sedunia',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'udinsedunia@email.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('0812-3456-7890'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text('Jakarta, Indonesia'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.work),
                    title: Text('Mahasiswa / Developer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}