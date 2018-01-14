//
//  RadioButton.swift
//  RadioButtonDemo
//
//  Created by Manish on 10/01/2018.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

public struct RadioButtonCircleHeight {
    let outer: CGFloat
    let inner: CGFloat
    let lineWidth: CGFloat
    let contentPadding: CGFloat
    
    init() {
        outer = 16
        inner = 7
        lineWidth = 2
        contentPadding = 6
    }
    
    init(outerCircle: CGFloat, innerCircle: CGFloat) {
        self.outer = outerCircle
        self.inner = innerCircle
        lineWidth = 2
        contentPadding = 6
    }
    
    init(outerCircle: CGFloat, innerCircle: CGFloat, outerCircleBorder: CGFloat) {
        outer = outerCircle
        inner = innerCircle
        lineWidth = outerCircleBorder
        contentPadding = 6
        
    }
    
    init(outerCircle: CGFloat, innerCircle: CGFloat, outerCircleBorder: CGFloat, contentPadding: CGFloat) {
        outer = outerCircle
        inner = innerCircle
        lineWidth = outerCircleBorder
        self.contentPadding = contentPadding
    }
    
}

public struct RadioButtonColor {
    let active: UIColor
    let inactive: UIColor
}

public protocol RadioButtonSelectionDelegate: RadioButtonDelegate {
    func radioButtonDidSelect(_ button: RadioButton)
}

public protocol RadioButtonDeselectionDelegate: RadioButtonDelegate {
    func radioButtonDidDeselect(_ button: RadioButton)
}

public protocol RadioButtonDelegate: class { }

public class RadioButton: UIButton {
    
    private var outerLayer = CAShapeLayer()
    private var innerLayer = CAShapeLayer()
    private var sizeChangeObserver: NSKeyValueObservation?
    
    public weak var delegate: RadioButtonDelegate?
    
    public var radioCircle = RadioButtonCircleHeight() {
        didSet { setup() }
    }
    
    public var radioButtonColor: RadioButtonColor! {
        didSet {
            innerLayer.fillColor = radioButtonColor.active.cgColor
            outerLayer.strokeColor = isActive ? radioButtonColor.active.cgColor : radioButtonColor.inactive.cgColor
        }
    }
    
    @objc dynamic public var isActive = false {
        didSet { 
            updateRadioLayer()
            callDelegate()
        }
    }
    
    public var allowDeselection: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        radioButtonColor = RadioButtonColor(active: tintColor, inactive: UIColor.lightGray)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        radioButtonColor = RadioButtonColor(active: tintColor, inactive: UIColor.lightGray)
        setup()
    }
    
    public convenience init?(type buttonType: UIButtonType) {
        return nil
    }
    
    public func updateRadioLayer() {
        if isActive { updateActiveRadioLayer() }
        else { updateInactiveRadioLayer() }
    }
    
    
    private func setup() {
        // Add action here
        addTarget(self, action: #selector(selectionAction), for: .touchUpInside)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: radioCircle.outer + radioCircle.contentPadding, bottom: 0, right: 0)
        contentHorizontalAlignment = .left
        
        setupLayer()
        addObserverSizeChange()
    }
    
    private func setupLayer() {
        // Add layer here
        addOuterLayer()
        addInnerLayer()
        updateRadioLayer()
        
    }
    
    @objc internal func selectionAction(_ sender: RadioButton) {
        // If toggle enable, change selection state
        if allowDeselection {
            isActive = !isActive
            
        } else if !isActive {
            isActive = true
        }
    }
    
}

// frame change handler
extension RadioButton {
    
    private func addObserverSizeChange() {
        sizeChangeObserver = observe(\RadioButton.center, changeHandler: sizeChangeObseveHandler)
    }
    
    private func sizeChangeObseveHandler(_ object: RadioButton, _ change: NSKeyValueObservedChange<CGPoint>) {
        setupLayer()
    }
    
}

// MARK: - Delegate calling
private extension RadioButton {
    
    private func callDelegate() {
        if isActive {
            (delegate as? RadioButtonSelectionDelegate)?.radioButtonDidSelect(self)
        } else {
            (delegate as? RadioButtonDeselectionDelegate)?.radioButtonDidDeselect(self)
        }
    }
}

// MARK:- Adding radio layer
private extension RadioButton {
    
    private func addOuterLayer() {
        outerLayer.removeFromSuperlayer()
        outerLayer.strokeColor = radioButtonColor.active.cgColor
        outerLayer.fillColor = UIColor.clear.cgColor
        outerLayer.lineWidth = radioCircle.lineWidth
        outerLayer.path = UIBezierPath.outerCircle(rect: bounds, circle: radioCircle).cgPath
        layer.insertSublayer(outerLayer, at: 1)
    }
    
    private func addInnerLayer() {
        innerLayer.removeFromSuperlayer()
        innerLayer.fillColor = radioButtonColor.active.cgColor
        innerLayer.strokeColor = UIColor.clear.cgColor
        innerLayer.lineWidth = 0
        innerLayer.path = UIBezierPath.innerCircle(rect: bounds, circle: radioCircle).cgPath
        layer.insertSublayer(innerLayer, at: 0)
    }
    
}

//MARK:- Updating current state of Radio button
private extension RadioButton {
    
    private func updateActiveRadioLayer() {
        innerLayer.position = .zero
        innerLayer.transform = CATransform3DIdentity
        outerLayer.strokeColor = radioButtonColor.active.cgColor
        
    }
    
    private func updateInactiveRadioLayer() {
        guard let rect = self.innerLayer.path?.boundingBox else { return }
        let point = CGPoint(x: rect.midX, y: rect.midY)
        innerLayer.position = point
        innerLayer.transform = CATransform3DMakeScale(0.00001, 0.00001, 1)
        outerLayer.strokeColor = radioButtonColor.inactive.cgColor
    }
    
}

//MARK:- Radio button layer path
private extension UIBezierPath {
    
    static func outerCircle(rect: CGRect, circle: RadioButtonCircleHeight) -> UIBezierPath {
        let size = CGSize(width: circle.outer, height: circle.outer)
        return UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: circle.lineWidth/2, y: rect.size.height/2-(circle.outer/2)), size: size))
    }
    
    static func innerCircle(rect: CGRect, circle: RadioButtonCircleHeight) -> UIBezierPath {
        let size = CGSize(width: circle.inner, height: circle.inner)
        let xPos = circle.outer/2 - circle.inner/2 + circle.lineWidth/2
        return UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: xPos, y: rect.size.height/2-(circle.inner/2)), size: size))
    }
    
}
