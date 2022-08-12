import 'package:route_core/route_core.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// 处理所有的@RoutePage注解
/// 将所有Element写入到内存中等待
class RoutePageGenerator extends GeneratorForAnnotation<RoutePage> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    /// 只有顶层节点（类、顶层函数等）才会被扫描
    /// 首先，被注解的应该是个类并且是可见类
    if (element.kind == ElementKind.CLASS && element.isPublic) {

      addImports(buildStep);

      //路由名称
      String? name;
      if (annotation.peek('name') != null) {
        //开发者指定了路由
        name = annotation.peek('name')?.stringValue;
      } else {
        //处理路由名称MyHomePage  my_home_page
        RegExp reg = RegExp(r"[A-Z]");
        name = element.name?.replaceAllMapped(reg, (match) {
          if (match.start == 0) {
            return "${element.name?.substring(match.start, match.end).toLowerCase()}";
          }
          return "_${element.name?.substring(match.start, match.end).toLowerCase()}";
        });
      }

      if (_result.containsKey(name)) {
        throw Exception("""
          
         ❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗
          路由文件生成失败！出现重复名称的路由:
          🌕 当前节点：
          类名: ${element.name}
          路由名: $name, 
          文件位置: ${buildStep.inputId.uri}
          🌚 相同的路由: 
          类名: ${_result[name]?.element.name}
          路由名: $name, 
          文件位置: ${_result[name]?.buildStep.inputId.uri}
         ❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗
        """);
      }
      _result[name!] = ParseDataForRoutePage(
          element: element,
          isConst: annotation.peek('isConst')!.boolValue,
          buildStep: buildStep);
    }

  }


  addImports(BuildStep buildStep) {
    String import = "import '${buildStep.inputId.uri}'";
    if (importsOriginal.contains(import)) return;
    importsOriginal.add(import);
    import += " as t${buildStep.inputId.hashCode};";
    _imports.add(import);
  }
}

/// 页面注解的处理结果
/// 路有名 : Element
Map<String, ParseDataForRoutePage> _result = {};

/// 记录对所有使用@RoutePage的文件或者library的import
List<String> _imports = [];
List<String> importsOriginal = [];

/// 处理@RouteManager注解
/// 将[RoutePageGenerator]写入内存的数据生成到RouteManager文件的同级目录下
/// @RouteManager在整个APP中仅可以使用一次
class RouteManagerGenerator extends GeneratorForAnnotation<RouteManager> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generate();
  }

  /// 生成文件的内容
  String _generate() {
    /// 文件引用部分
    String partForImports = "";
    for (var element in _imports) {
      partForImports += element;
      partForImports += '\n';
    }

    String partForBody = """
      Map<String, Function> appRoutes = {
          ${_createRouteMapString()}
      };
    """;

    ///警告部分
    String partForWarning = """ 
      ///系统生成文件，千万不要手动编辑!!!
      ///系统生成文件，千万不要手动编辑!!!
      ///系统生成文件，千万不要手动编辑!!!
    """;

    return """ 
    
    // ignore_for_file: implementation_imports
    
    $partForWarning
    
    $partForImports
    
    $partForBody
    
    $partForWarning
    """;
  }

  String _createRouteMapString() {
    String str = '';
    _result.forEach((key, value) {
      str += """
      '$key': (context, {arguments}) => ${value.isConst ? 'const ' : ''}t${value.buildStep.inputId.hashCode}.${value.element.name}(),
      """;
      str += "\n";
    });
    return str;
  }
}

/// 解析数据的结构体
/// [element] builder解析的对象
/// [isConst] 当前类是否使用了const构造函数
class ParseDataForRoutePage {
  late Element element;
  late bool isConst;
  late BuildStep buildStep;

  ParseDataForRoutePage(
      {required this.element, required this.isConst, required this.buildStep});
}
