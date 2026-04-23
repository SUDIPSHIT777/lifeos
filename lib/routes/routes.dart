import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/utils/navigationbar.dart';
import 'package:lifeos/feature/dashboard/ui/dashboard.dart';
import 'package:lifeos/feature/dashboard/ui/weatherpage.dart';
import 'package:lifeos/feature/tasks/ui/taskpageui.dart';
import 'package:lifeos/login/googleauth/authgate.dart';
import 'package:lifeos/login/loginscreen/ui/loginscreen.dart';
import 'package:lifeos/login/signupscreen/ui/signupscreen.dart';

class Routes {
  final GoRouter router = GoRouter(
    navigatorKey: Get.key,
    routes: [
      GoRoute(path: '/', builder: (context, state) => Authgate()),
      GoRoute(path: '/signup', builder: (context, state) => Signupscreen()),
      GoRoute(path: '/login', builder: (context, state) => Loginscreen()),
      GoRoute(path: '/taskpageui', builder: (context, state) => Taskpageui()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => Dashboard(),
        routes: [
          GoRoute(
            path: 'weatherpage',
            builder: (context, state) => Weatherpage(),
          ),
        ],
      ),
      GoRoute(path: '/navdar', builder: (context, state) => Navigationbar()),
    ],
  );
}
