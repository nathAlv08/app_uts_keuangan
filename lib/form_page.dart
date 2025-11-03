import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_uts/transaksi_model.dart';

class FormPage extends StatefulWidget {
  final Transaksi? transaksiToEdit;

  const FormPage({Key? key, this.transaksiToEdit}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final _jumlahController = TextEditingController();
  late TipeTransaksi _tipe;

  @override
  void initState() {
    super.initState();
    if (widget.transaksiToEdit != null) {

      final data = widget.transaksiToEdit!;
      _keteranganController.text = data.keterangan;
      _jumlahController.text = data.jumlah.toString();
      _tipe = data.tipe;
    } else {

      _tipe = TipeTransaksi.pengeluaran;
    }
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      final bool isEditMode = widget.transaksiToEdit != null;

      final newItem = Transaksi(
        id: isEditMode
            ? widget.transaksiToEdit!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        keterangan: _keteranganController.text,
        jumlah: int.parse(_jumlahController.text),
        tipe: _tipe,
        tanggal: isEditMode
            ? widget.transaksiToEdit!.tanggal
            : DateTime.now(),
      );
      Navigator.pop(context, newItem);
    }
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = widget.transaksiToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Transaksi' : 'Tambah Transaksi Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SegmentedButton<TipeTransaksi>(
                segments: const [
                  ButtonSegment(
                    value: TipeTransaksi.pengeluaran,
                    label: Text('Pengeluaran'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: TipeTransaksi.pemasukan,
                    label: Text('Pemasukan'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_tipe},
                onSelectionChanged: (Set<TipeTransaksi> newSelection) {
                  setState(() {
                    _tipe = newSelection.first;
                  });
                },
                style: const ButtonStyle(
                  visualDensity: VisualDensity(horizontal: -1, vertical: -1),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Input harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _simpanData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text(isEditMode ? 'Simpan Perubahan' : 'Simpan Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}