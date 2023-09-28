package com.softradix.hichartdemo;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

// For BindView with factory component.
class SankeyDiagramFactory extends PlatformViewFactory {
    Activity activity;

    SankeyDiagramFactory(@org.jetbrains.annotations.Nullable Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.activity = activity;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new SankeyDiagramView(activity, id, creationParams);
    }
}
