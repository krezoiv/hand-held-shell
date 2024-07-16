import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final PageController mainPageController;
  final int pageIndex;
  final int totalPages;
  final Function clearTextField;
  final int currentCardIndex; // Cambia el tipo a RxInt

  const NavigationButtons({
    required this.mainPageController,
    required this.pageIndex,
    required this.totalPages,
    required this.clearTextField,
    required this.currentCardIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.arrowshape_turn_up_left,
              onPressed: () {
                if (pageIndex > 0) {
                  mainPageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: Icons.update,
              backgroundColor: Colors.yellow.shade900,
              onPressed: () {
                clearTextField(pageIndex,
                    currentCardIndex); // Usa .value para obtener el valor entero
              },
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: Icons.save_outlined,
              backgroundColor: Colors.green[600]!,
              onPressed: () {
                // Acción cuando se presiona el botón Thumb Up
              },
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.arrowshape_turn_up_right,
              onPressed: () {
                if (pageIndex < totalPages - 1) {
                  mainPageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    Color? backgroundColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), backgroundColor: backgroundColor ?? Colors.blue,
        padding: EdgeInsets.all(15), // Fondo predeterminado azul
      ),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
