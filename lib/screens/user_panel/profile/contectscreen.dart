import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Get in Touch",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text("Email: moayadothman623@gmail.com"),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => launch("tel:+963 966 327 142"), // رقم الهاتف
              child: const Text(
                "Phone: +963 966 327 142",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              // onTap: () => launch("https://www.example.com"), // رابط الموقع
              child: const Text(
                "Website: www.example.com",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              // onTap: () => launch("https://facebook.com/example"), // رابط فيسبوك
              child: const Text(
                "Facebook: facebook.com/example",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Send us a message:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Your message",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // إضافة منطق لإرسال الرسالة إذا كان هناك طريقة لذلك
              },
              child: const Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
