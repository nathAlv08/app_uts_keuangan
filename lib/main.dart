// main.dart
import 'package:flutter/material.dart';
import 'package:app_uts/home_page.dart';
import 'package:app_uts/form_page.dart';
import 'package:app_uts/transaksi_model.dart';
import 'package:google_fonts/google_fonts.dart'; // Impor Font

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final List<Transaksi> _dataList = [];

  void _handleThemeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  // --- LOGIKA INTI APLIKASI ---

  void _addTransaksi(Transaksi transaksi) {
    setState(() {
      _dataList.add(transaksi);
    });
  }

  void _editTransaksi(Transaksi transaksi) {
    setState(() {
      final index = _dataList.indexWhere((item) => item.id == transaksi.id);
      if (index != -1) {
        _dataList[index] = transaksi;
      }
    });
  }

  void _deleteTransaksi(String id) {
    setState(() {
      _dataList.removeWhere((item) => item.id == id);
    });
  }

  void _navigateToForm(BuildContext context, {Transaksi? transaksiToEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(
          transaksiToEdit: transaksiToEdit,
        ),
      ),
    );

    if (result != null && result is Transaksi) {
      if (transaksiToEdit != null) {
        _editTransaksi(result);
      } else {
        _addTransaksi(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Keuangan',

      // Terapkan font Poppins ke seluruh tema
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.white),
        ),
      ),

      themeMode: _themeMode,

      home: HomePage(
        currentThemeMode: _themeMode,
        onThemeChanged: _handleThemeChanged,
        dataList: _dataList,
        navigateToForm: _navigateToForm,
        deleteTransaksi: _deleteTransaksi,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}