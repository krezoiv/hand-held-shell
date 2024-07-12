import 'package:get/get.dart';
import 'package:hand_held_shell/config/theme/app.theme.dart';

class ThemeController extends GetxController {
  var appTheme = AppTheme().obs;

  void toggleDarkmode() {
    appTheme.value =
        appTheme.value.copyWith(isDarkmode: !appTheme.value.isDarkmode);
  }

  void changeColorIndex(int colorIndex) {
    appTheme.value = appTheme.value.copyWith(selectedColor: colorIndex);
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