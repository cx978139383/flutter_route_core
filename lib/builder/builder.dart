import 'package:route_core/generator/generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

/// [RouteManager]的builder
Builder builderForRouteManager(BuilderOptions options) => LibraryBuilder(RouteManagerGenerator(), generatedExtension: '.app.routes.dart');

/// [RoutePage]的builder
Builder builderForRoutePage(BuilderOptions options) => LibraryBuilder(RoutePageGenerator(), generatedExtension: '.page.dart');