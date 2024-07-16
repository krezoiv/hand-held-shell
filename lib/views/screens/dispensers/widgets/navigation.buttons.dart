import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavigationButtons extends StatelessWidget {
  final PageController mainPageController;
  final int pageIndex;
  final int totalPages;
  final Function clearTextField;
  final int currentCardIndex;
  final bool enabled;

  const NavigationButtons({
    Key? key,
    required this.mainPageController,
    required this.pageIndex,
    required this.totalPages,
    required this.clearTextField,
    required this.currentCardIndex,
    required this.enabled,
  }) : super(key: key);

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
              onPressed: enabled && pageIndex > 0
                  ? () {
                      mainPageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  : null,
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: Icons.clear,
              backgroundColor: Colors.red[400]!,
              onPressed: enabled
                  ? () {
                      clearTextField(pageIndex, currentCardIndex);
                    }
                  : null,
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.hand_thumbsup,
              backgroundColor: Colors.green[600]!,
              onPressed: enabled
                  ? () {
                      // Acción cuando se presiona el botón Thumb Up
                      // Puedes agregar aquí la lógica que necesites
                    }
                  : null,
            ),
          ),
          SizedBox(width: 25),
          Expanded(
            child: _buildNavigationButton(
              icon: CupertinoIcons.arrowshape_turn_up_right,
              onPressed: enabled && pageIndex < totalPages - 1
                  ? () {
                      mainPageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color backgroundColor = Colors.deepPurpleAccent,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        elevation: onPressed != null ? 5 : 0,
        shadowColor: backgroundColor.withOpacity(0.5),
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 20,
          color: onPressed != null ? Colors.white : Colors.grey[400],
        ),
      ),
    );
  }
}
