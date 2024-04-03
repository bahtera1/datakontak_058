import 'dart:io';

import 'package:data_kontak/controller/kontak_controller.dart';
import 'package:data_kontak/model/kontak_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormKontak extends StatefulWidget {
  const FormKontak({super.key});

  @override
  State<FormKontak> createState() => _FormKontakState();
}

class _FormKontakState extends State<FormKontak> {
  File? _image;
  final _imagePicker = ImagePicker();

  final _formkey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();

  Future<void> getImage() async {
    final XFile? pickerFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    Future<void> getImage() async {
      final XFile? pickerFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(
      () {
        if (pickerFile != null) {
          _image = File(pickerFile.path);
        } else {
          print("No image selected");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration:
                  InputDecoration(labelText: "Nama", hintText: "Masukkan Nama"),
              controller: _namaController,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Email", hintText: "Masukkan Email"),
              controller: _emailController,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "Alamat", hintText: "Masukkan Alamat"),
              controller: _alamatController,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: "No Telepon", hintText: "Masukkan No Telepon"),
              controller: _noTeleponController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: SizedBox(
              child: Text("No Image Selected"),
            ),
          ),
          _image == null
              ? const Text("Tidak ada data yang dipilih")
              : Image.file(_image!),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                getImage();
              },
              child: const Text("Pilih Gambar"),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  //Proses simpan data
                  var result = await KontakController().addPerson(
                      Kontak(
                          nama: _namaController.text,
                          email: _emailController.text,
                          alamat: _alamatController.text,
                          telepon: _noTeleponController.text,
                          foto: _image!.path),
                      _image);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message']),
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}
