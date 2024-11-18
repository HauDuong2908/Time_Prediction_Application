import 'package:go_router/go_router.dart';
import 'package:weather_app/widget/Home_Page/HomePage_Widget.dart';
import 'package:weather_app/widget/get_started.dart';
import 'package:weather_app/widget/welcom.dart';

class RouterWidget {
  static final GoRouter router = GoRouter(
    initialLocation: '/get-started',
    routes: [
      GoRoute(
        path: '/get-started',
        builder: (context, state) => getStarted(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => Welcom(),
      ),
      GoRoute(
        path: '/home-page',
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}
