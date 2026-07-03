import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/utils/navigationbar.dart';
import 'package:lifeos/feature/ai_assistant/ui/aiassistent.dart';
import 'package:lifeos/feature/ai_assistant/ui/aidashboard.dart';
import 'package:lifeos/feature/dashboard/ui/dashboard.dart';
import 'package:lifeos/feature/dashboard/ui/weatherpage.dart';
import 'package:lifeos/feature/tasks/ui/taskdetails.dart';
import 'package:lifeos/feature/tasks/ui/taskpageui.dart';
import 'package:lifeos/login/googleauth/authgate.dart';
import 'package:lifeos/login/loginscreen/ui/loginscreen.dart';
import 'package:lifeos/login/signupscreen/ui/signupscreen.dart';
import 'package:lifeos/model/taskmodel.dart';

class Routes {
  final GoRouter router = GoRouter(
    navigatorKey: Get.key,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Authgate()),
      GoRoute(path: '/signup', builder: (context, state) => const Signupscreen()),
      GoRoute(path: '/login', builder: (context, state) => const Loginscreen()),
      GoRoute(
        path: '/taskpageui',
        builder: (context, state) => const Taskpageui(),
        routes: [
          GoRoute(
            name: 'taskDetails',
            path: 'taskdetails',
            builder: (context, state) {
              final task = state.extra as TaskModel;
              return Taskdetails(alltaskdetails: task);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
        routes: [
          GoRoute(
            path: 'weatherpage',
            builder: (context, state) => const Weatherpage(),
          ),
        ],
      ),
      GoRoute(path: '/navdar', builder: (context, state) => const Navigationbar()),
      GoRoute(
        path: '/aidashboard',
        builder: (context, state) => const AiDashboard(),
        routes: [
          GoRoute(
            path: 'chatboat',
            builder: (context, state) => const AiassistentPage(),
          ),
        ],
      ),
    ],
  );
}
