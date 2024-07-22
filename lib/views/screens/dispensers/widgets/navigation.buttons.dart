import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';

class NavigationButtons extends StatelessWidget {
  final PageController mainPageController;
  final int pageIndex;
  final int totalPages;
  final int currentCardIndex;
  final bool enabled;
  final VoidCallback onThumbUpPressed;
  final DispenserController dispenserController;

  const NavigationButtons({
    Key? key,
    required this.mainPageController,
    required this.pageIndex,
    required this.totalPages,
    required this.currentCardIndex,
    required this.enabled,
    required this.onThumbUpPressed,
    required this.dispenserController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: pageIndex > 0 ? () => _changePage(pageIndex - 1) : null,
          ),
          Obx(() => IconButton(
                icon: Icon(Icons.sync, color: Colors.cyanAccent[700]),
                onPressed: dispenserController.canClearFields(pageIndex)
                    ? () {
                        // No hace nada cuando se presiona
                        print('Clear button pressed, but no action taken');
                      }
                    : null,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 180,
              child: Obx(() => ElevatedButton(
                    onPressed: enabled &&
                            !dispenserController.dataSubmitted[pageIndex].value
                        ? onThumbUpPressed
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                    child: dispenserController.isLoading.value
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Enviando información',
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const Icon(Icons.thumb_up),
                  )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: pageIndex < totalPages - 1
                ? () => _changePage(pageIndex + 1)
                : null,
          ),
        ],
      ),
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
