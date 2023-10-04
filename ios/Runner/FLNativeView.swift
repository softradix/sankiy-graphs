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
 let chartView = HIChartView(frame: parentView.bounds)
        chartView.plugins = ["sankey"]
        let options = HIOptions()
        let title = HITitle()
        title.text = "Highcharts Sankey Diagram"
        options.title = title
        let accessibility = HIAccessibility()
        accessibility.point = HIPoint()
        accessibility.point.valueDescriptionFormat = "{index}. {point.from} to {point.to}, {point.weight}."
        options.accessibility = accessibility
        let sankey = HISankey()
        sankey.name = "Sankey demo series"
        sankey.keys = ["from", "to", "weight"]
        sankey.data = [
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
          ["Morocco", "Japan", 3]
          ] as [Any]
        options.series = [sankey]
        chartView.options = options
        return chartView;
    }
}

