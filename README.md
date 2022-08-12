## 使用方式

1. app pubspec.yaml中添加route_core;
```yaml
dependencies:
  route_core:
    path: ./route_core
```

2. 新建类继承自[IRouteManager]并添加[@RouteManager]注解
```dart
@RouteManager()
class AppManager extends IRouteManager {
  @override
  Route onGenerateRoute() {
    // TODO: implement onGenerateRoute
    throw UnimplementedError();
  }
}
```
3. 在要使用命名式路由的页面上使用[@RoutePage]
```dart
@RoutePage(name: 'yangyuxi')
class PageA extends StatefulWidget {
  const PageA({Key? key}) : super(key: key);

  @override
  _PageAState createState() => _PageAState();
}
```

4. app 根目录下添加 build.yaml
```yaml
targets:
  $default:
    builders:
      route_core|route_page_builder:
        # 扫描lib下所有dart文件
        generate_for:
          - lib/**/*.dart
      route_core|route_manager_builder:
        # 只针对这个文件生成路由文件
        generate_for:
          - lib/route/manager.dart
```
指定生成器的扫描文件路径

5. 执行脚本
```shell
#! /bin/bash
# 路由生成脚本

#移动到脚本存在的当前目录
cd `dirname $0`

#打印当前工作目录
pwd

#清理
flutter packages pub run build_runner clean

#构建
flutter packages pub run build_runner build --delete-conflicting-outputs

```

6. 文件会生成在第2步RouteManager文件的同级目录下
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RouteManagerGenerator
// **************************************************************************

///系统生成文件，千万不要手动编辑!!!
///系统生成文件，千万不要手动编辑!!!
///系统生成文件，千万不要手动编辑!!!

import 'package:flutter_architecture/route/test/test.dart';
import 'package:flutter_architecture/route/page/page.dart';

final appRoutes = {
  '/test': (context, {arguments}) => const Test(),
  '/yangyuxi': (context, {arguments}) => const PageA(),
};

///系统生成文件，千万不要手动编辑!!!
///系统生成文件，千万不要手动编辑!!!
///系统生成文件，千万不要手动编辑!!!

```
文件名xx.app.route.dart