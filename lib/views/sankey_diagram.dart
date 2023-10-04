import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class SankeyDiagram extends StatefulWidget {
  const SankeyDiagram({super.key});

  @override
  State<SankeyDiagram> createState() => _SankeyDiagramState();
}

class _SankeyDiagramState extends State<SankeyDiagram> {
  var android = Platform.isAndroid;
  var ios = Platform.isIOS;

  // This is used in the platform side to register the view.
  final String viewType = '<platform-view-type-sankey-diagram>';
// Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{"title": "Highcharts Sankey Diagram Daman","seriesName":"Flow"};
  GlobalKey _platformViewKey = GlobalKey();
  bool? rebuild;
  @override
  Widget build(BuildContext context) {
    creationParams['dataList']=dataList();
    final platform = Theme.of(context).platform;
    if (rebuild != null) {
      _platformViewKey = GlobalKey();
      rebuild = null;
    }
    rebuild ??= true;
    var size = MediaQuery.of(context).size;
    switch (platform) {
      case TargetPlatform.android:
        return Scaffold(
            body: SafeArea(
              child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.white,
                  child: Stack(fit: StackFit.expand, children: [
                    loadingWidget(),
                    androidNativeView()
                  ])),
            ));

      case TargetPlatform.iOS:
        return Scaffold(
            body: SafeArea(
              child: Container(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      loadingWidget(),
                      iosNativeView()
                    ],
                  )),
            ));
      default:
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text('Target device not support.'),
        );
    }
  }

  Widget loadingWidget(){
    return const Center(
      child: Text('Loading....',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal),),
    );
  }
  // For ios native view call/return
  UiKitView iosNativeView(){
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  // For android native view call/return
  PlatformViewLink androidNativeView(){
    return PlatformViewLink(
      key: _platformViewKey,
      viewType: viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<
              OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(
              params.onPlatformViewCreated)
          ..create();
      },
    );
  }
  List<dynamic> dataList() {
    List<List<Object>> dataList = [
      ["Brazil", "Portugal", 5],
      ["Brazil", "France", 1],
      ["Brazil", "Spain", 1],
      ["Brazil", "England", 1],
      ["Canada", "Portugal", 1],
      ["Canada", "France", 5],
      ["Canada", "England", 1],
      ["Mexico", "Portugal", 1],
      ["Mexico", "France", 1],
      ["Mexico", "Spain", 5],
      ["Mexico", "England", 1],
      ["USA", "Portugal", 1],
      ["USA", "France", 1],
      ["USA", "Spain", 1],
      ["USA", "England", 5],
      ["Portugal", "Angola", 2],
      ["Portugal", "Senegal", 1],
      ["Portugal", "Morocco", 1],
      ["Portugal", "South Africa", 3],
      ["France", "Angola", 1],
      ["France", "Senegal", 3],
      ["France", "Mali", 3],
      ["France", "Morocco", 3],
      ["France", "South Africa", 1],
      ["Spain", "Senegal", 1],
      ["Spain", "Morocco", 3],
      ["Spain", "South Africa", 1],
      ["England", "Angola", 1],
      ["England", "Senegal", 1],
      ["England", "Morocco", 2],
      ["England", "South Africa", 7],
      ["South Africa", "China", 5],
      ["South Africa", "India", 1],
      ["South Africa", "Japan", 3],
      ["Angola", "China", 5],
      ["Angola", "India", 1],
      ["Angola", "Japan", 3],
      ["Senegal", "China", 5],
      ["Senegal", "India", 1],
      ["Senegal", "Japan", 3],
      ["Mali", "China", 5],
      ["Mali", "India", 1],
      ["Mali", "Japan", 3],
      ["Morocco", "China", 5],
      ["Morocco", "India", 1],
      ["Morocco", "Japan", 3],
    ];
    return dataList;
  }
}


