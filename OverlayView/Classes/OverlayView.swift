//
//  OverlayView.swift
//  OverlayKiy
//
//  Created by Suhail on 30/04/23.


import Foundation

public class OverlayView: UIView {
    
    private var blackOverlay: UIControl = UIControl()
    private var imageData: UIImage? // default is nil
    fileprivate var containerView: UIView! // default is nil
    fileprivate var contentView: UIView! // default is nil
    fileprivate var showPoint: CGPoint! // default is nil
    fileprivate var customViewData: CustomDataModel? // default is nil
    
    
    /// It will create intial view with zero frame and clear background
    /// - Parameter data: data to be used to create custom view
    public init(data: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.accessibilityViewIsModal = true
        if let customViewDataTemp = DataHelper.decodJson(data: data) {
            customViewData = customViewDataTemp
            imageData = DataHelper.getImageData(url: customViewDataTemp.image?.url ?? "")
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Create Intial view for be dispalyed as Overlay.
    open func createOverlay() {
        guard let rootView = (UIApplication.shared.keyWindow) else {
            return
        }
        guard let customData = customViewData else {return}
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: rootView.frame.width - 40, height: rootView.frame.height - 220))
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: customData.image?.height ?? 0)
        if let image = imageData {
            imageView.image = image
        }
        contentView.addSubview(imageView)

        let labelHeight = contentView.frame.height-(customData.image?.height ?? 0 + 60)
        let label = UILabel(frame: CGRect(x: 0, y: (customData.image?.height ?? 0), width: contentView.frame.width, height: labelHeight))
        label.text = customViewData?.text ?? ""
        label.numberOfLines = 0
        label.textAlignment = .center
        contentView.addSubview(label)
        createBottomView(customData: customData, contentView: contentView)
        
        show(contentView, point: CGPoint(x: 0, y: 110), inView: rootView)
    }
    
    
    // To be used to create bottom view
    /// - Parameters:
    ///   - customData: To be used to get buttons details from the data
    ///   - contentView: A view where create buttons will be added
    private func createBottomView(customData: CustomDataModel, contentView: UIView) {
        var index = 0
        var x: CGFloat = 5
        for button in customData.buttons! {
            let buttonTemp = UIButton()
            buttonTemp.backgroundColor = UIColor(red:0, green:0.478431, blue:1, alpha: 1)
            buttonTemp.frame = CGRect(x: x, y: contentView.frame.height-((button.size?.height ?? 0)+5), width: button.size?.width ?? 0, height: button.size?.height ?? 0)
            buttonTemp.setTitle(button.text, for: .normal)
            buttonTemp.tag = index
            buttonTemp.addTarget(self, action: #selector(bottomBtnTapped(_:)), for: .touchUpInside)
            buttonTemp.contentMode = UIViewContentMode.center
            contentView.addSubview(buttonTemp)
            x += contentView.frame.width - ((button.size?.width ?? 0)+10)
            index += 1
        }
    }
    
    //  To be called to redirect on the specific url
    /// - Parameter button: A button object from where this is invoked
    @objc func bottomBtnTapped( _ button : UIButton)
     {
         if let url = customViewData!.buttons![button.tag].redirect_url {
             UIApplication.shared.open(URL(string: url)!)
         }
    }
    
    //  To be called for remove the overlay view from super view
    @objc open func dismiss() {
        if self.superview != nil {
            UIView.animate(withDuration: 0.1, delay: 0,
                           options: UIView.AnimationOptions(),
                           animations: {
                self.blackOverlay.alpha = 0
            }){ _ in
                self.contentView.removeFromSuperview()
                self.blackOverlay.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    
    
    /// To be overrided to draw white view over the black overlay.
    /// - Parameter rect: <#rect description#>
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        let color = UIColor.white
        let point = self.containerView.convert(self.showPoint, to: self)
        path.move(to: CGPoint(x: point.x, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        color.setFill()
        path.fill()
    }
}

private extension OverlayView {
    
    /// To be called for create black overlay
    /// - Parameters:
    ///   - contentView: A view which will be shown as overlay
    ///   - point: A point where overlay will be shown
    ///   - inView: A view on which overlay will be show.
    private func show(_ contentView: UIView, point: CGPoint, inView: UIView) {
        self.blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blackOverlay.frame = inView.bounds
        inView.addSubview(self.blackOverlay)
        self.blackOverlay.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        self.blackOverlay.alpha = 0
        self.containerView = inView
        self.contentView = contentView
        self.contentView.layer.masksToBounds = true
        self.showPoint = point
        self.blackOverlay.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.show()
    }
    
    /// Create frame for black overlay view
    private func create() {
        var frame = self.contentView.frame
        frame.origin.x += abs(frame.minX) + 20
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        frame.origin.y = self.showPoint.y
        let lastAnchor = self.layer.anchorPoint
        self.layer.anchorPoint = anchorPoint
        let x = self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width
        let y = self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height
        self.layer.position = CGPoint(x: x, y: y)
        self.frame = frame
    }
    
    /// To be used to show created overlay on the screen with animatation
    private func show() {
        self.setNeedsDisplay()
        self.contentView.frame.origin.y = 0
        self.addSubview(self.contentView)
        self.containerView.addSubview(self)
        self.create()
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 3,
            options: UIView.AnimationOptions(),
            animations: {
                self.transform = CGAffineTransform.identity
            })
        UIView.animate(
            withDuration: 0.6 / 3,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.blackOverlay.alpha = 1
            }, completion: nil)
    }
}
