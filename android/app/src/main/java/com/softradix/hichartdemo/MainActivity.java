package com.softradix.hichartdemo;

import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // For register native code according to viewType.
        flutterEngine
                .getPlatformViewsController()
                .getRegistry()
                .registerViewFactory("<platform-view-type-sankey-diagram>", new SankeyDiagramFactory(getActivity()));
    }
}
