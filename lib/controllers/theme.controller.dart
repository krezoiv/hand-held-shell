import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/config/theme/app.theme.dart';

const List<Color> predefinedColorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
];

class ThemeController extends GetxController {
  final StorageService _storageService = StorageService();

  final _isDarkMode = false.obs;
  final _selectedColorIndex = 0.obs;

  bool get isDarkMode => _isDarkMode.value;
  int get selectedColorIndex => _selectedColorIndex.value;

  List<Color> get colorList => predefinedColorList;

  Rx<AppTheme> get appTheme => AppTheme(
        selectedColor: _selectedColorIndex.value,
        isDarkmode: _isDarkMode.value,
      ).obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void toggleDarkMode() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _storageService.writeData('isDarkMode', _isDarkMode.value.toString());
  }

  void changeColorIndex(int index) async {
    _selectedColorIndex.value = index;
    await _storageService.writeData('selectedColorIndex', index.toString());
  }

  void _loadThemeFromStorage() async {
    final isDarkModeString = await _storageService.readData('isDarkMode');
    final selectedColorIndexString =
        await _storageService.readData('selectedColorIndex');

    if (isDarkModeString != null) {
      _isDarkMode.value = isDarkModeString == 'true';
    }
    if (selectedColorIndexString != null) {
      _selectedColorIndex.value = int.parse(selectedColorIndexString);
    }
  }
}

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> writeData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}

// // Listado de colores inmutable
// import 'package:hand_held_shell/config/theme/app.theme.dart';
// import 'package:riverpod/riverpod.dart';

// final colorListProvider = Provider((ref) => colorList);

// // Un simple boolean
// final isDarkmodeProvider = StateProvider((ref) => false);

// // Un simple int
// final selectedColorProvider = StateProvider((ref) => 0);




// // Un objeto de tipo AppTheme (custom)
// final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
//   (ref) => ThemeNotifier(),
// );


// // Controller o Notifier
// class ThemeNotifier extends StateNotifier<AppTheme> {
  
//   // STATE = Estado = new AppTheme();
//   ThemeNotifier(): super( AppTheme() );


//   void toggleDarkmode() {
//     state = state.copyWith( isDarkmode: !state.isDarkmode  );
//   }

//   void changeColorIndex( int colorIndex) {
//     state = state.copyWith( selectedColor: colorIndex );
//   }


// }