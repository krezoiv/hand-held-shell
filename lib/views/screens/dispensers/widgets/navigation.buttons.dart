import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:hand_held_shell/controllers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class NavigationButtons extends StatefulWidget {
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
  _NavigationButtonsState createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = Get.find<ThemeController>();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.pageIndex > 0
                ? () => _changePage(widget.pageIndex - 1)
                : null,
          ),
          Obx(() {
            final bool isEnabled =
                widget.dispenserController.canClearFields(widget.pageIndex);
            final bool isDarkMode = themeController.isDarkMode;
            return AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: isEnabled ? -_controller.value * 2 * math.pi : 0,
                  child: child,
                );
              },
              child: IconButton(
                icon: Icon(
                  Icons.sync,
                  color: isEnabled
                      ? Colors.cyanAccent[700]
                      : (isDarkMode ? Colors.white : Colors.black),
                ),
                onPressed: isEnabled
                    ? () {
                        print('Clear button pressed, but no action taken');
                      }
                    : null,
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 180,
              child: Obx(() => ElevatedButton(
                    onPressed: widget.enabled &&
                            !widget.dispenserController
                                .dataSubmitted[widget.pageIndex].value
                        ? widget.onThumbUpPressed
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                    ),
                    child: widget.dispenserController.isLoading.value
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
            onPressed: widget.pageIndex < widget.totalPages - 1
                ? () => _changePage(widget.pageIndex + 1)
                : null,
          ),
        ],
      ),
    );
  }

  void _changePage(int newPage) {
    if (widget.mainPageController.hasClients) {
      widget.mainPageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
