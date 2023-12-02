import 'package:flutter/material.dart';
import 'package:yoko_mind/screens/public/auth.dart';
import 'package:yoko_mind/screens/teacher/index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case AuthPage.route:
        return CustomPageRoute(
          child: const AuthPage(),
          settings: settings,
        );

      // case StudentView.route:
      //   return CustomPageRoute(
      //     child: const StudentView(),
      //     settings: settings,
      //   );
      // case NoteBookView.route:
      //   if (args is Map) {
      //     return CustomPageRoute(
      //       child: const NoteBookView(),
      //       settings: settings,
      //     );
      //   }
      //   return _errorRoute("no arguments delcared", settings);

      case QrReader.route:
        return CustomPageRoute(
          child: const QrReader(),
          settings: settings,
        );

      default:
        return _errorRoute(settings.name, settings);
    }
  }

  static Route<dynamic> _errorRoute(name, settings) {
    return CustomPageRoute(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            'No route defined for $name',
          ),
        ),
      ),
      settings: settings,
    );
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({
    required this.child,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          settings: settings,
        );

  @override
  bool get opaque => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
