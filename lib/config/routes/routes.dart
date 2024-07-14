import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/config/routes/exports.routes.files.dart';

class AppRoutes {
  static final routes = [
    ...AuthRoutes.routes,
    ...UsersRoutes.routes,
    ...LubricantsRoutes.routes,
    ...HomeRoutes.routes,
    ...DispensersRoutes.routes,
    ...SettingsRoutes.routes,
    ...ShopsRoutes.routes,
    ...SalesRoutes.routes
  ];

  static String get initialRoute => RoutesPaths.loadingHome;
  static Type get home => HomeRoutes;
  static Type get auth => AuthRoutes;
  static Type get lubricants => LubricantsRoutes;
  static Type get sales => SalesRoutes;
  static Type get settings => SettingsRoutes;
  static Type get shops => ShopsRoutes;
  static Type get users => UsersRoutes;
}
