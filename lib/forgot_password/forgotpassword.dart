import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final String _baseUrl = 'https://www.smt-online.com/api';

  void _sendResetLink() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forgot-password'),
      body: {'email': _emailController.text},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending reset link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ลืมรหัสผ่าน",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "กรอกอีเมลของคุณเพื่อรีเซ็ตรหัสผ่าน",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 330,
            height: 50,
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelText: "อีเมล",
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: _sendResetLink,
            child: Container(
              width: 330,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Center(
                  child: Text(
                "รีเซ็ตรหัสผ่าน",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
