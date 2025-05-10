import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPromoBanner extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
 

  const ProductPromoBanner({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
   
  });



  Future<void> _launchURL() async {
  final Uri uri = Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLScoiE2hKE5Uj0s_t-p2R8zzKX6vmuW80icepnZIiHu2_M-nbA/viewform?usp=dialog");

  if (!await launchUrl(
    uri,
    mode: LaunchMode.platformDefault, // ou LaunchMode.externalApplication
  )) {
    throw 'Não foi possível abrir o link $uri';
  }

  FirebaseAnalytics.instance.logEvent(
      name: 'botao_avaliar_clicado',
      parameters: {
       
        'label': 'Botao Avaliar',
      },
    );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _launchURL,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0072FF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
