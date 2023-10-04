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
  final Map<String, dynamic> creationParams = <String, dynamic>{"daman": "Testing"};
  GlobalKey _platformViewKey = GlobalKey();
  bool? rebuild;
  @override
  Widget build(BuildContext context) {
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
}

