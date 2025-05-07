import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/primary_button.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode integrar com um backend ou enviar por email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem enviada! Responderemos em breve.')),
      );
      _messageController.clear();
    }
  }
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,mode: LaunchMode.platformDefault, // ou LaunchMode.externalApplication
      );
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Precisa de ajuda? Entre em contato conosco:',
                      style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "Poppins"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                    onPressed: () => _launchURL('https://wa.me/message/CW7K3AWF66LJL1'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.chat, color: Colors.white),
                    label: const Text(
                      'Fale conosco no WhatsApp',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                   const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _launchURL('https://www.instagram.com/laicasolutions/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'Entre em contato no Instagram',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                   
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
