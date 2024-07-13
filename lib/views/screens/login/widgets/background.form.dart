import 'package:flutter/material.dart';

class BackgroundForm extends StatelessWidget {
  final Widget child;
  final String backgroundImage;
  const BackgroundForm(
      {super.key, required this.child, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: backgroundColor),
          ),

          // Imagen de fondo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: size.width * .5, // Ajusta este valor para cambiar el ancho
              height: size.height * 0.39,
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Child widget
          child,
        ],
      ),
    );
  }
}
