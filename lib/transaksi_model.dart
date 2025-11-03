// transaksi_model.dart
import 'package:hive/hive.dart';

part 'transaksi_model.g.dart'; // Ini akan dibuat otomatis

@HiveType(typeId: 1) // Beri ID unik untuk enum
enum TipeTransaksi {
  @HiveField(0)
  pemasukan,

  @HiveField(1)
  pengeluaran
}

@HiveType(typeId: 0) // Beri ID unik untuk class
class Transaksi extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String keterangan;

  @HiveField(2)
  final int jumlah;

  @HiveField(3)
  final TipeTransaksi tipe;

  @HiveField(4)
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.keterangan,
    required this.jumlah,
    required this.tipe,
    required this.tanggal,
  });
}