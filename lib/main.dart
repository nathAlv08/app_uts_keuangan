// main.dart
import 'package:flutter/material.dart';
import 'package:app_uts/home_page.dart';
import 'package:app_uts/form_page.dart';
import 'package:app_uts/transaksi_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransaksiAdapter());
  Hive.registerAdapter(TipeTransaksiAdapter());

  await Hive.openBox<Transaksi>('transaksiBox');

  // --- PERUBAHAN 1: Buka Box untuk Pengaturan ---
  await Hive.openBox('settingsBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // --- PERUBAHAN 2: Baca nilai tema dari Hive ---
  // Kita beri nilai default 'false' (light mode) jika belum ada
  ThemeMode _themeMode = Hive.box('settingsBox').get('isDark', defaultValue: false)
      ? ThemeMode.dark
      : ThemeMode.light;

  void _handleThemeChanged(ThemeMode mode) {
    // --- PERUBAHAN 3: Simpan pilihan tema ke Hive ---
    bool isDark = mode == ThemeMode.dark;
    Hive.box('settingsBox').put('isDark', isDark);

    setState(() {
      _themeMode = mode;
    });
  }

  // --- (Semua fungsi CRUD: _add, _edit, _delete, _navigateToForm
  //       TIDAK BERUBAH SAMA SEKALI) ---

  void _addTransaksi(Transaksi transaksi) {
    Hive.box<Transaksi>('transaksiBox').put(transaksi.id, transaksi);
  }

  void _editTransaksi(Transaksi transaksi) {
    Hive.box<Transaksi>('transaksiBox').put(transaksi.id, transaksi);
  }

  void _deleteTransaksi(String id) {
    Hive.box<Transaksi>('transaksiBox').delete(id);
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

      // Gunakan _themeMode yang sudah di-load dari Hive
      themeMode: _themeMode,

      home: ValueListenableBuilder(
        valueListenable: Hive.box<Transaksi>('transaksiBox').listenable(),
        builder: (context, Box<Transaksi> box, _) {
          final dataList = box.values.toList();

          return HomePage(
            // Pastikan _themeMode yang terbaru (dari state) dikirim ke HomePage
            currentThemeMode: _themeMode,
            onThemeChanged: _handleThemeChanged,
            dataList: dataList,
            navigateToForm: _navigateToForm,
            deleteTransaksi: _deleteTransaksi,
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}