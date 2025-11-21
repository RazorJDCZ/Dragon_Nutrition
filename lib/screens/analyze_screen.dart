import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/openai_service.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  File? _image;
  String result = "";
  bool loading = false;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() => _image = File(picked.path));
      analyzeImage();
    }
  }

  Future analyzeImage() async {
    if (_image == null) return;

    setState(() => loading = true);

    final response = await OpenAIService.analyzeFoodImage(_image!);

    setState(() {
      result = response["raw"];
      loading = false;
    });

    Navigator.pop(context, response["data"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analyze Meal")),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),

            _image == null
                ? const Text("Take a picture of your meal")
                : Image.file(_image!, height: 200),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator(color: Colors.amber)
                : Text(result, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text("Take Picture", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
