part of route_core;

/// RouteManager注解的类
///
/// 将@RouteManager放置于实现[IRouteManager]的类顶部
/// ```dart
/// @RoutManager()
/// class AppRouteManager extends IRouteManager {}
/// ```
class RouteManager {
  const RouteManager();
}

/// RoutePage 注解类
///
/// 将@Route放置于页面类顶部一般是[StatefulWidget]
/// ```dart
/// @Route(name: 'hello')
/// class PageA extends StatefulWidget {}
/// ```
///
/// [isConst] 是否使用了const 构造函数 默认是true
class RoutePage {
  final String name;
  final bool isConst;
  const RoutePage({required this.name, this.isConst = true});
}