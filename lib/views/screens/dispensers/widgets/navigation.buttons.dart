import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';

class NavigationButtons extends StatelessWidget {
  final PageController mainPageController;
  final int pageIndex;
  final int totalPages;
  final Function(int, int) clearTextField;
  final int currentCardIndex;
  final bool enabled;
  final VoidCallback onThumbUpPressed;
  final DispenserController dispenserController;
  final Function(int) onUpdatePressed;

  const NavigationButtons({
    Key? key,
    required this.mainPageController,
    required this.pageIndex,
    required this.totalPages,
    required this.clearTextField,
    required this.currentCardIndex,
    required this.enabled,
    required this.onThumbUpPressed,
    required this.dispenserController,
    required this.onUpdatePressed,
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
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: enabled
                ? () => clearTextField(pageIndex, currentCardIndex)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 180, // Ajusta este valor según tus necesidades
              child: Obx(() => ElevatedButton(
                    onPressed: enabled &&
                            !dispenserController
                                .showUpdateButtonList[pageIndex].value
                        ? () {
                            onThumbUpPressed();
                            dispenserController
                                .showUpdateButtonList[pageIndex].value = true;
                          }
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
          Obx(() => Visibility(
                visible:
                    dispenserController.showUpdateButtonList[pageIndex].value,
                child: IconButton(
                  icon: const Icon(Icons.update),
                  color: Colors.orange[400],
                  onPressed: () => onUpdatePressed(pageIndex),
                ),
              )),
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
