import 'dart:io';

import 'package:data_kontak/presentation/controller/kontak_controller.dart';
import 'package:data_kontak/domain/model/kontak_model.dart';
import 'package:data_kontak/presentation/screen/home_view.dart';
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

  final KontakController _personController = KontakController();

  Future<void> getImage() async {
    final XFile? pickerFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Kontak"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 200, 210, 214),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Nama", hintText: "Masukkan Nama"),
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
            SizedBox(
              height: 50,
            ),
            _image == null
                ? const Text("Tidak ada gambar yang dipilih")
                : Image.file(_image!),
            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 35),
              child: ElevatedButton(
                onPressed: () {
                  getImage();
                },
                child: Text("Pilih Gambar"),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();
                    Kontak _person = Kontak(
                      nama: _namaController.text,
                      email: _emailController.text,
                      alamat: _alamatController.text,
                      noTelepon: _noTeleponController.text,
                      foto: _image!.path,
                    );
                    // Proses simpan data
                    var result =
                        await _personController.addPerson(_person, _image);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'])),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                      (route) => false,
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
