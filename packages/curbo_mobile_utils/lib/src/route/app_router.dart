import 'package:flutter/material.dart';

typedef AppHandlerFunc = Widget Function(dynamic);
typedef TransitionsBuilder = Widget Function(
    BuildContext, Animation<double>, Animation<double>, Widget);

enum Transition {
  platform,
  fade,
  rightSlide,
  upSlide,
}

class AppRouteHandler {
  final AppHandlerFunc handlerFunc;

  AppRouteHandler({required this.handlerFunc});
}

class AppRoute {
  final String path;
  final AppRouteHandler handler;
  final Transition? transition;

  AppRoute(
    this.path,
    this.handler, {
    this.transition = Transition.platform,
  });
}

class AppRouter {
  static final appRouter = AppRouter();

  final List<AppRoute> routes = [];

  void define({
    required String routePath,
    required AppRouteHandler handler,
    Transition? transition,
  }) {
    routes.add(AppRoute(routePath, handler, transition: transition));
  }

  Route<dynamic> matchRoute(String path, {RouteSettings? routeSettings}) {
    final AppRoute? routeMatched =
        routes.firstWhere((route) => route.path == path);

    if (routeMatched != null) {
      final transition = routeMatched.transition;

      switch (transition) {
        case Transition.rightSlide:
        case Transition.upSlide:
          return _builPageRouteBuilder(
            path,
            routeMatched,
            (_, animation, __, child) {
              var offsetAnimation =
                  _buildSlideAnimation(animation, transition!);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            routeSettings: routeSettings,
          );
        case Transition.fade:
          return _builPageRouteBuilder(
            path,
            routeMatched,
            (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            routeSettings: routeSettings,
          );
        case Transition.platform:
        default:
          return MaterialPageRoute(
            settings: RouteSettings(
              name: path,
              arguments: routeSettings?.arguments,
            ),
            builder: (_) =>
                routeMatched.handler.handlerFunc(routeSettings?.arguments),
          );
      }
    }

    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('path no implement'),
        ),
      ),
    );
  }

  PageRouteBuilder _builPageRouteBuilder(
    String path,
    AppRoute routeMatched,
    TransitionsBuilder transitionsBuilder, {
    RouteSettings? routeSettings,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(
        name: path,
        arguments: routeSettings?.arguments,
      ),
      transitionsBuilder: transitionsBuilder,
      pageBuilder: (_, __, ___) =>
          routeMatched.handler.handlerFunc(routeSettings?.arguments),
    );
  }

  Animation<Offset> _buildSlideAnimation(
    Animation<double> animation,
    Transition transition,
  ) {
    var begin = Offset(1.0, 0.0);

    switch (transition) {
      case Transition.upSlide:
        begin = Offset(0.0, 1.0);
        break;
      case Transition.rightSlide:
      default:
        begin = Offset(1.0, 0.0);
    }

    var end = Offset.zero;
    var curve = Curves.ease;
    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    return animation.drive(tween);
  }
}
