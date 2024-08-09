import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/services/fuel.statation/dispenser.reader.service.dart';
import 'package:hand_held_shell/shared/helpers/show.confirm.alert.dart';
import 'package:hand_held_shell/views/screens/dispensers/screens/register.dispenser.page.screen.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/side.menu.dispenser.dart';

class NewRegisterDispenserScreen extends StatefulWidget {
  const NewRegisterDispenserScreen({super.key});

  @override
  _NewRegisterDispenserScreenState createState() =>
      _NewRegisterDispenserScreenState();
}

class _NewRegisterDispenserScreenState
    extends State<NewRegisterDispenserScreen> {
  late DispenserController dispenserController;
  late PageController _pageController;
  final RxInt currentPageIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // Definir scaffoldKey

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    Get.put(_pageController, tag: 'dispenser_page_controller');

    if (!Get.isRegistered<DispenserController>()) {
      Get.put(DispenserController());
    }
    dispenserController = Get.find<DispenserController>();

    // Carga el estado al iniciar
    dispenserController.loadState();

    // Añade un listener al PageController para actualizar currentPageIndex
    _pageController.addListener(() {
      currentPageIndex.value = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    Get.delete<PageController>(tag: 'dispenser_page_controller');
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey, // Utilizar scaffoldKey
      drawer: SideMenuDispenser(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: Text(
          'Digitar de Bomba',
          style: TextStyle(
              fontSize: screenWidth * 0.05), // Ajuste de tamaño de fuente
        ),
        actions: [
          Obx(() => CupertinoButton(
                onPressed: dispenserController.hasSharedPreferencesData.value &&
                        dispenserController.isAnyButtonDisabledInCards
                    ? () {
                        dispenserController
                            .toggleEditMode(currentPageIndex.value);
                      }
                    : null,
                child: Icon(
                  CupertinoIcons.pencil,
                  color: (dispenserController.hasSharedPreferencesData.value &&
                          dispenserController.isAnyButtonDisabledInCards)
                      ? Colors.blue[900]
                      : Colors.grey,
                ),
              )),
          Obx(() => CupertinoButton(
                onPressed: dispenserController.hasSharedPreferencesData.value
                    ? () {
                        showConfirmationDialog(
                          title: 'Eliminar Último Dispensador',
                          message:
                              '¿Confirmar eliminación del último dispensador?',
                          confirmText: 'Sí',
                          cancelText: 'No',
                          onConfirm: () async {
                            try {
                              await DispenserReaderService
                                  .deleteLastGeneralDispenserReader();
                              await dispenserController.clearState();
                              Get.back();
                              Get.toNamed(RoutesPaths.dispensersHome);
                            } catch (e) {}
                          },
                          onCancel: () {
                            return;
                          },
                        );
                      }
                    : null,
                child: Icon(
                  CupertinoIcons.delete,
                  color: Colors.red[900],
                ),
              )),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            if (dispenserController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return PageView.builder(
                controller: _pageController,
                itemCount: dispenserController.dispenserReaders.length,
                onPageChanged: (index) {
                  dispenserController.setFocusToFirstField(index);
                  currentPageIndex.value = index;
                },
                itemBuilder: (context, index) {
                  final dispenserReader =
                      dispenserController.dispenserReaders[index];
                  return RegisterDispenserPage(
                    pageIndex: index,
                    dispenserReader: dispenserReader,
                    totalPages: dispenserController.dispenserReaders.length,
                    mainPageController: _pageController,
                    showCalculatorButtons:
                        dispenserController.showCalculatorButtons,
                    buttonsEnabled:
                        dispenserController.hasSharedPreferencesData,
                    dispenserReaderId:
                        dispenserReader['dispenserReaderId'] as String?,
                  );
                },
              );
            }
          }),
          Obx(() => Positioned(
                right: 36,
                bottom: 150,
                child: !dispenserController.hasSharedPreferencesData.value
                    ? IconButton(
                        onPressed: () {
                          showConfirmationDialog(
                            title: 'APERTURA DE DÍA',
                            message: '¿Confirmar apertura de día?',
                            confirmText: 'Sí',
                            cancelText: 'No',
                            onConfirm: () async {
                              try {
                                await DispenserReaderService
                                    .createGeneralDispenserReader();
                                dispenserController
                                    .showCalculatorButtons.value = true;
                                dispenserController
                                    .hasSharedPreferencesData.value = true;
                                await dispenserController.saveState();
                                // Get.back();
                              } catch (e) {}
                            },
                            onCancel: () {
                              return;
                            },
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.folder_badge_plus,
                          size: 60,
                          color: Colors.teal.shade600,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      )
                    : SizedBox.shrink(),
              )),
        ],
      ),
    );
  }
}

// class RegisterDispenserPage extends StatefulWidget {
//   final int pageIndex;
//   final dynamic dispenserReader;
//   final int totalPages;
//   final PageController mainPageController;
//   final RxBool showCalculatorButtons;
//   final RxBool buttonsEnabled;
//   final String? dispenserReaderId;

//   const RegisterDispenserPage({
//     super.key,
//     required this.pageIndex,
//     required this.dispenserReader,
//     required this.totalPages,
//     required this.mainPageController,
//     required this.showCalculatorButtons,
//     required this.buttonsEnabled,
//     this.dispenserReaderId,
//   });

//   @override
//   _RegisterDispenserPageState createState() => _RegisterDispenserPageState();
// }

// class _RegisterDispenserPageState extends State<RegisterDispenserPage> {
//   final themeController = Get.find<ThemeController>();
//   final dispenserController = Get.find<DispenserController>();
//   late RegisterButtonsController calculatorCtrl;
//   late PageController verticalPageController;

//   @override
//   void initState() {
//     super.initState();
//     calculatorCtrl = Get.put(RegisterButtonsController());
//     calculatorCtrl.setDispenserController(dispenserController);
//     verticalPageController = PageController();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context)
//           .requestFocus(dispenserController.focusNodes[widget.pageIndex][0]);
//     });

//     widget.mainPageController.addListener(_onPageChanged);
//   }

//   @override
//   void dispose() {
//     verticalPageController.dispose();
//     widget.mainPageController.removeListener(_onPageChanged);
//     super.dispose();
//   }

//   void _onPageChanged() {
//     if (widget.mainPageController.page == widget.pageIndex) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         FocusScope.of(context)
//             .requestFocus(dispenserController.focusNodes[widget.pageIndex][0]);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scaffoldKey = GlobalKey<ScaffoldState>();

//     String fuelName = '';
//     String sideName = '';
//     String dispenserCode = '';
//     String assignmentHoseId = '';

//     final assignmentHoseIdMap = widget.dispenserReader['assignmentHoseId'];
//     if (assignmentHoseIdMap is Map) {
//       final hoseIdMap = assignmentHoseIdMap['hoseId'];
//       final sideIdMap = assignmentHoseIdMap['sideId'];
//       final assignmentIdMap = assignmentHoseIdMap['assignmentId'];

//       if (hoseIdMap is Map && sideIdMap is Map && assignmentIdMap is Map) {
//         final fuelIdMap = hoseIdMap['fuelId'];
//         final dispenserIdMap = assignmentIdMap['dispenserId'];

//         if (fuelIdMap is Map && dispenserIdMap is Map) {
//           fuelName = fuelIdMap['fuelName'] as String;
//           sideName = sideIdMap['sideName'] as String;
//           dispenserCode = dispenserIdMap['dispenserCode'] as String;
//           assignmentHoseId = assignmentHoseIdMap['_id'] as String;
//         } else {
//           // Manejar el caso donde fuelIdMap o dispenserIdMap no sean Map
//         }
//       } else {
//         // Manejar el caso donde hoseIdMap, sideIdMap o assignmentIdMap no sean Map
//       }
//     } else {
//       // Manejar el caso donde assignmentHoseIdMap no sea Map
//     }

//     return Obx(() => Scaffold(
//           key: scaffoldKey,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             toolbarHeight: 20,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Icon(Icons.local_gas_station),
//                 const SizedBox(width: 5),
//                 Expanded(
//                     child: Text(
//                         '$fuelName | ${TextHelpers.capitalizeFirstLetterOfEachWord(dispenserCode)} -> ${TextHelpers.capitalizeFirstLetterOfEachWord(sideName)}',
//                         style: const TextStyle(fontSize: 14.0),
//                         overflow: TextOverflow.ellipsis)),
//                 Text('${widget.pageIndex + 1}/${widget.totalPages}',
//                     style: const TextStyle(
//                         fontSize: 12, fontStyle: FontStyle.italic)),
//               ],
//             ),
//           ),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.22,
//                     child: PageView(
//                       scrollDirection: Axis.vertical,
//                       controller: verticalPageController,
//                       onPageChanged: (index) {
//                         calculatorCtrl.setCurrentCardIndex(index);
//                         if (index == 0) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             FocusScope.of(context).requestFocus(
//                                 dispenserController.focusNodes[widget.pageIndex]
//                                     [0]);
//                           });
//                         }
//                       },
//                       children: [
//                         RegisterCard(
//                           title: 'No. en Galones',
//                           value: widget.dispenserReader['actualNoGallons']
//                               .toString(),
//                           cardIndex: 0,
//                           difference: dispenserController
//                               .differences[widget.pageIndex][0].value,
//                           titleColor: Colors.blue[900],
//                           themeController: themeController,
//                           dispenserController: dispenserController,
//                           pageIndex: widget.pageIndex,
//                         ),
//                         RegisterCard(
//                           title: 'No. Mecánica',
//                           value: widget.dispenserReader['actualNoMechanic']
//                               .toString(),
//                           cardIndex: 1,
//                           difference: dispenserController
//                               .differences[widget.pageIndex][1].value,
//                           titleColor: Colors.blue[900],
//                           themeController: themeController,
//                           dispenserController: dispenserController,
//                           pageIndex: widget.pageIndex,
//                         ),
//                         RegisterCard(
//                           title: 'No. en Dinero',
//                           value: widget.dispenserReader['actualNoMoney']
//                               .toString(),
//                           cardIndex: 2,
//                           difference: dispenserController
//                               .differences[widget.pageIndex][2].value,
//                           titleColor: Colors.blue[900],
//                           themeController: themeController,
//                           dispenserController: dispenserController,
//                           pageIndex: widget.pageIndex,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Obx(() => NavigationButtons(
//                         mainPageController: widget.mainPageController,
//                         pageIndex: widget.pageIndex,
//                         totalPages: widget.totalPages,
//                         currentCardIndex: calculatorCtrl.currentCardIndex.value,
//                         enabled: widget.buttonsEnabled.value &&
//                             !dispenserController
//                                 .dataSubmitted[widget.pageIndex].value &&
//                             !dispenserController.isLoading.value,
//                         onThumbUpPressed: () {
//                           if (dispenserController.sendButtonEnabled.value &&
//                               !dispenserController
//                                   .dataSubmitted[widget.pageIndex].value &&
//                               !dispenserController.isLoading.value) {
//                             dispenserController.sendDataToDatabase(widget
//                                 .pageIndex); // !se manade a guardar el nuevo dispenserReader
//                           } else if (dispenserController
//                               .dataSubmitted[widget.pageIndex].value) {
//                             Get.snackbar('Información',
//                                 'Los datos ya han sido enviados.');
//                           } else if (dispenserController.isLoading.value) {
//                             Get.snackbar('Información',
//                                 'Enviando datos, por favor espere...');
//                           } else {
//                             ShowMissingDataDialog.show(
//                                 context, dispenserController, widget.pageIndex);
//                           }
//                         },
//                         dispenserController: dispenserController,
//                       )),
//                   if (widget.showCalculatorButtons.value)
//                     BuildCalculatorButtons(
//                       pageIndex: widget.pageIndex,
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }