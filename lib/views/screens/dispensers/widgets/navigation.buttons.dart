import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationButtons extends StatelessWidget {
  final PageController mainPageController;
  final int pageIndex;
  final int totalPages;
  final Function(int, int) clearTextField;
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: pageIndex > 0 ? () => _changePage(pageIndex - 1) : null,
          child: Icon(Icons.arrow_back),
        ),
        ElevatedButton(
          onPressed: enabled
              ? () => clearTextField(pageIndex, currentCardIndex)
              : null,
          child: Icon(Icons.clear),
        ),
        ElevatedButton(
          onPressed: enabled ? onThumbUpPressed : null,
          child: Icon(Icons.thumb_up),
        ),
        ElevatedButton(
          onPressed: pageIndex < totalPages - 1
              ? () => _changePage(pageIndex + 1)
              : null,
          child: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  void _changePage(int newPage) {
    if (mainPageController.hasClients) {
      mainPageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
