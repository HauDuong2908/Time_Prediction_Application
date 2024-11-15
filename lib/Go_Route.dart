import 'package:go_router/go_router.dart';
import 'package:weather_app/widget/Home_Page/HomePage_Widget.dart';
import 'package:weather_app/widget/get_started.dart';
import 'package:weather_app/widget/welcom.dart';

class RouterWidget {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/getStarted',
        builder: (context, state) => getStarted(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => Welcom(),
      ),
      GoRoute(
        path: '/homePage',
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}
