import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class NavigationButtons extends StatelessWidget {
  final PageController mainPageController;
  final int pageIndex;
  final int totalPages;
  final void Function(int, int) clearTextField;
  final int currentCardIndex;
  final bool enabled;
  final VoidCallback onThumbUpPressed;

  const NavigationButtons({
    Key? key,
    required this.mainPageController,
    required this.pageIndex,
    required this.totalPages,
    required this.clearTextField,
    required this.currentCardIndex,
    required this.enabled,
    required this.onThumbUpPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNavigationButton(
          icon: Icons.arrow_back,
          backgroundColor: Colors.blue[600]!,
          onPressed: pageIndex > 0
              ? () {
                  mainPageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              : null,
        ),
        _buildNavigationButton(
          icon: CupertinoIcons.hand_thumbsup,
          backgroundColor: Colors.green[600]!,
          onPressed: enabled ? onThumbUpPressed : null,
        ),
        _buildNavigationButton(
          icon: Icons.arrow_forward,
          backgroundColor: Colors.blue[600]!,
          onPressed: pageIndex < totalPages - 1
              ? () {
                  mainPageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: CircleBorder(),
        padding: EdgeInsets.all(16),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
