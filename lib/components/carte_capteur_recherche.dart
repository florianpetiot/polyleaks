import 'package:flutter/material.dart';
import 'package:polyleaks/components/point_clignotant.dart';

class CarteCapteurRecherche extends StatelessWidget {
  const CarteCapteurRecherche({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 185,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFB7B7B7),
            width: 1,
          ),
        ),
      
        // Contenu de la carte ---------------------------------------------------
        // un point bleu aligné avec un texte au centre vertical de la carte
        // la hauteur de la carte prend toute la hauteur disponible
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlinkingDot(),
            Text(
              'Recherche...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
       
      
      ),
    );
  }
}
