package com.softradix.hichartdemo;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.highsoft.highcharts.common.HIColor;
import com.highsoft.highcharts.common.hichartsclasses.HINodes;
import com.highsoft.highcharts.common.hichartsclasses.HIOptions;
import com.highsoft.highcharts.common.hichartsclasses.HISankey;
import com.highsoft.highcharts.common.hichartsclasses.HITitle;
import com.highsoft.highcharts.common.hichartsclasses.HITooltip;
import com.highsoft.highcharts.core.HIChartView;
import com.highsoft.highcharts.core.HIFunction;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

import io.flutter.plugin.platform.PlatformView;

// SankeyDiagramView component class for native view.
class SankeyDiagramView implements PlatformView {
    private HIChartView hIChartView;

    SankeyDiagramView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        // for add Chart to view.
        addSankeyChart(context,creationParams);
    }

    @NonNull
    public View getView() {
        return hIChartView;
    }

    @Override
    public void dispose() {
    }
    void addSankeyChart(Context context, Map<String, Object> creationParams){
        String title = "Chart";
        String seriesName = "Chart";
        List<List<Object>> dataList = new ArrayList<>();
        int [] arr=new int [4];
        if(creationParams.containsKey("title")){
            title = (String) creationParams.get("title");
        }
        if(creationParams.containsKey("seriesName")){
            seriesName = (String) creationParams.get("seriesName");
        }
        if(creationParams.containsKey("dataList")){
            List<List<Object>> list = ( List<List<Object>> ) creationParams.get("dataList");
            dataList.addAll(list);
        }
        hIChartView = new HIChartView(context);
        hIChartView.theme= "brand-dark";
        hIChartView.showLoading("Loading....");
        hIChartView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        hIChartView.setBackgroundColor(context.getResources().getColor(android.R.color.transparent));
        hIChartView.plugins = new ArrayList<>(Arrays.asList("sankey"));
        HIOptions options = new HIOptions();
        HITitle titlee = new HITitle();
        titlee.setText(title);
        options.setTitle(titlee);
        String[] keys = new String[]{"from", "to", "weight"};
        HISankey series1 = new HISankey();
        series1.setKeys(new ArrayList<>(Arrays.asList(keys)));
        series1.setName(seriesName);
        series1.setData(new ArrayList<>(dataList));
        options.setSeries(new ArrayList<>(Arrays.asList(series1)));
        hIChartView.setOptions(options);
    }
}