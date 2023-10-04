import Flutter
import UIKit
import Highcharts

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var arg:Any?
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        arg = args
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.white
        
        
        //get sankey view
        var view = getSankeyDiagramView(parentView: _view);
        
        //ger screen width, height
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        //set to, bottom, leading and traling equal to the _view.
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: _view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: _view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: _view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: _view, attribute: .trailing, multiplier: 1, constant: 0)
        
        
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        _view.addSubview(view)
        _view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        _view.layoutIfNeeded()
        
    }
    
    
    
    func getSankeyDiagramView(parentView : UIView) -> UIView{
        var titlee: String = "Chart"
        var seriesNamee: String = "Chart"
        var dataListt: [[Any]] = []
        if let title = (arg as AnyObject)["title"]! as? String {
            titlee = title
        }
        if let seriesName = (arg as AnyObject) ["seriesName"]! as? String {
            seriesNamee = seriesName
        }
        if let dataList = (arg as AnyObject)["dataList"]! as? [[Any]] {
            dataListt = dataList
        }
        let chartView = HIChartView(frame: parentView.bounds)
        chartView.plugins = ["sankey"]
        let options = HIOptions()
        let title = HITitle()
        title.text = titlee
        options.title = title
        let accessibility = HIAccessibility()
        accessibility.point = HIPoint()
        accessibility.point.valueDescriptionFormat = "{index}. {point.from} to {point.to}, {point.weight}."
        options.accessibility = accessibility
        let sankey = HISankey()
        sankey.name = seriesNamee
        sankey.keys = ["from", "to", "weight"]
        sankey.data = dataListt
        options.series = [sankey]
        chartView.options = options
        return chartView;
    }
}

