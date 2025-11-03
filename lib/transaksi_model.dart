// transaksi_model.dart

enum TipeTransaksi { pemasukan, pengeluaran }

class Transaksi {
  final String id;
  final String keterangan;
  final int jumlah;
  final TipeTransaksi tipe;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.keterangan,
    required this.jumlah,
    required this.tipe,
    required this.tanggal,
  });
}