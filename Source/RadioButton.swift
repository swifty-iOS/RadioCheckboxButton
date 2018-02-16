//
//  RadioButton.swift
//  RadioButtonDemo
//
//  Created by Manish on 10/01/2018.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

// MARK: RadioButtonCircleStyle

/// Define RadioButtonCircleStyle

public struct RadioButtonCircleStyle {
    let outer: CGFloat
    let inner: CGFloat
    let lineWidth: CGFloat
    let contentPadding: CGFloat
    
    init(outerCircle: CGFloat = 16, innerCircle: CGFloat = 7, outerCircleBorder: CGFloat = 2, contentPadding: CGFloat = 6) {
        self.outer = outerCircle
        self.inner = innerCircle
        self.lineWidth = outerCircleBorder
        self.contentPadding = contentPadding
    }
    
    init(outerCircle: CGFloat, innerCircle: CGFloat) {
        self.init(outerCircle: outerCircle, innerCircle: innerCircle, outerCircleBorder: 2, contentPadding: 6)
    }
    
    init(outerCircle: CGFloat, innerCircle: CGFloat, outerCircleBorder: CGFloat) {
        self.init(outerCircle: outerCircle, innerCircle: innerCircle, outerCircleBorder: outerCircleBorder, contentPadding: 6)
    }
}

// MARK:- RadioButtonColor

/// Define RadioButtonColor

public struct RadioButtonColor {
    let active: UIColor
    let inactive: UIColor
}

// MARK:- RadioButtonDelegate
public protocol RadioButtonDelegate: class {
    
    func radioButtonDidSelect(_ button: RadioButton)
    func radioButtonDidDeselect(_ button: RadioButton)
    
}

// MARK:- RadioCheckboxBaseButton
public class RadioButton: RadioCheckboxBaseButton {
    
    private var outerLayer = CAShapeLayer()
    private var innerLayer = CAShapeLayer()
    private var sizeChangeObserver: NSKeyValueObservation?
    
    public weak var delegate: RadioButtonDelegate?
    
    /// Apply RadioButtonCircleStyle
    public var radioCircle = RadioButtonCircleStyle() {
        didSet { setupLayer() }
    }
    
    /// Apply RadioButtonColor
    public var radioButtonColor: RadioButtonColor! {
        didSet {
            innerLayer.fillColor = radioButtonColor.active.cgColor
            outerLayer.strokeColor = isActive ? radioButtonColor.active.cgColor : radioButtonColor.inactive.cgColor
        }
    }
    
    /// Don't allow deselectio of Radio button as per standart radio button feature
    override internal var allowDeselection: Bool {
        return false
    }
    
    /// Do initial stuff here
    /// Setting default color style
    override internal func setup() {
        radioButtonColor = RadioButtonColor(active: tintColor, inactive: UIColor.lightGray)
        super.setup()
    }
    
    /// Create layer for Radio button
    override internal func setupLayer() {
        contentEdgeInsets = UIEdgeInsets(top: 0, left: radioCircle.outer + radioCircle.contentPadding, bottom: 0, right: 0)
        // Add layer here
        func addOuterLayer() {
            outerLayer.strokeColor = radioButtonColor.active.cgColor
            outerLayer.fillColor = UIColor.clear.cgColor
            outerLayer.lineWidth = radioCircle.lineWidth
            outerLayer.path = UIBezierPath.outerCircle(rect: bounds, circle: radioCircle).cgPath
            outerLayer.removeFromSuperlayer()
            layer.insertSublayer(outerLayer, at: 1)
        }
        
        func addInnerLayer() {
            innerLayer.fillColor = radioButtonColor.active.cgColor
            innerLayer.strokeColor = UIColor.clear.cgColor
            innerLayer.lineWidth = 0
            innerLayer.path = UIBezierPath.innerCircle(rect: bounds, circle: radioCircle).cgPath
            innerLayer.removeFromSuperlayer()
            layer.insertSublayer(innerLayer, at: 0)
        }
        
        addOuterLayer()
        addInnerLayer()
        super.setupLayer()
    }
    
    /// Call to delegate
    override internal func callDelegate() {
        if isActive {
            delegate?.radioButtonDidSelect(self)
        } else {
            delegate?.radioButtonDidDeselect(self)
        }
    }
    
    /// Updating active layers
    override internal func updateActiveLayer() {
        super.updateActiveLayer()
        innerLayer.position = .zero
        innerLayer.transform = CATransform3DIdentity
        outerLayer.strokeColor = radioButtonColor.active.cgColor
    }
    
    /// Updating inactive layers
    override internal func updateInactiveLayer() {
        super.updateInactiveLayer()
        guard let rect = self.innerLayer.path?.boundingBox else { return }
        let point = CGPoint(x: rect.midX, y: rect.midY)
        innerLayer.position = point
        innerLayer.transform = CATransform3DMakeScale(0.00001, 0.00001, 1)
        outerLayer.strokeColor = radioButtonColor.inactive.cgColor
    }
    
}

// MARK:- Radio button layer path
private extension UIBezierPath {
    
    static func outerCircle(rect: CGRect, circle: RadioButtonCircleStyle) -> UIBezierPath {
        let size = CGSize(width: circle.outer, height: circle.outer)
        return UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: circle.lineWidth/2, y: rect.size.height/2-(circle.outer/2)), size: size))
    }
    
    static func innerCircle(rect: CGRect, circle: RadioButtonCircleStyle) -> UIBezierPath {
        let size = CGSize(width: circle.inner, height: circle.inner)
        let xPos = circle.outer/2 - circle.inner/2 + circle.lineWidth/2
        return UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: xPos, y: rect.size.height/2-(circle.inner/2)), size: size))
    }
    
}
