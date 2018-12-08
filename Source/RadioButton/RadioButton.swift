//
//  RadioButton.swift
//  RadioCheckboxButton
//
//  Created by Manish on 10/01/2018.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

// MARK:- RadioButtonDelegate
public protocol RadioButtonDelegate: class {
    
    /// Delegate called when radio button is Selected
    ///
    /// - Parameter button: RadioButton
    func radioButtonDidSelect(_ button: RadioButton)
    
    /// Delegate called when radio button is deselected
    /// It will call automatically when user choose different radio button than selected
    ///
    /// - Parameter button: RadioButton
    func radioButtonDidDeselect(_ button: RadioButton)
    
}

// MARK:- RadioLayer
internal class RadioLayer: CAShapeLayer {
    /// Path for active layer
    var activePath: CGPath?
    
    /// Path for inactive layer
    var inactivePath: CGPath?
}

// MARK:- RadioCheckboxBaseButton
public class RadioButton: RadioCheckboxBaseButton {
    
    private var outerLayer = CAShapeLayer()
    private var innerLayer = RadioLayer()
    
    private var sizeChangeObserver: NSKeyValueObservation?
    
    /// Set your delegate handler
    public weak var delegate: RadioButtonDelegate?
    
    /// Apply RadioButtonCircleStyle
    public var radioCircle = RadioButtonCircleStyle() {
        didSet { setupLayer() }
    }
    
    /// Apply RadioButtonColor
    public var radioButtonColor: RadioButtonColor! {
        didSet {
            innerLayer.fillColor = radioButtonColor.active.cgColor
            outerLayer.strokeColor = isOn ? radioButtonColor.active.cgColor : radioButtonColor.inactive.cgColor
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
        style = .circle
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
            outerLayer.path = UIBezierPath.outerCircle(rect: bounds, circle: radioCircle, style: style).cgPath
            outerLayer.removeFromSuperlayer()
            layer.insertSublayer(outerLayer, at: 0)
        }
        
        func addInnerLayer() {
            guard let rect = outerLayer.path?.boundingBox else { return }
            innerLayer.fillColor = radioButtonColor.active.cgColor
            innerLayer.strokeColor = UIColor.clear.cgColor
            innerLayer.lineWidth = 0
            innerLayer.activePath = UIBezierPath.innerCircleActive(rect: rect, circle: radioCircle, style: style).cgPath
            innerLayer.inactivePath = UIBezierPath.innerCircleInactive(rect: rect).cgPath
            innerLayer.path = innerLayer.inactivePath
            innerLayer.removeFromSuperlayer()
            outerLayer.insertSublayer(innerLayer, at: 0)
        }
        
        addOuterLayer()
        addInnerLayer()
        super.setupLayer()
    }
    
    /// Call to delegate
    override internal func callDelegate() {
        if isOn {
            delegate?.radioButtonDidSelect(self)
        } else {
            delegate?.radioButtonDidDeselect(self)
        }
    }
    
    /// Updating active layers
    override internal func updateActiveLayer() {
        super.updateActiveLayer()
        outerLayer.strokeColor = radioButtonColor.active.cgColor
        guard let start = innerLayer.path, let end = innerLayer.activePath else { return }
        innerLayer.animatePath(start: start, end: end)
        innerLayer.path = end
        
    }
    
    /// Updating inactive layers
    override internal func updateInactiveLayer() {
        super.updateInactiveLayer()
        outerLayer.strokeColor = radioButtonColor.inactive.cgColor
        guard let start = innerLayer.path, let end = innerLayer.inactivePath else { return }
        innerLayer.animatePath(start: start, end: end)
        innerLayer.path = end
    }
    
}

// MARK:- Radio button layer path
private extension UIBezierPath {
    
    /// Get outer circle layer
    static func outerCircle(rect: CGRect, circle: RadioButtonCircleStyle, style: RadioCheckboxStyle) -> UIBezierPath {
        let size = CGSize(width: circle.outer, height: circle.outer)
        let newRect = CGRect(origin: CGPoint(x: circle.lineWidth/2, y: rect.size.height/2-(circle.outer/2)), size: size)
        switch style {
        case .circle: return UIBezierPath(roundedRect: newRect, cornerRadius: size.height/2)
        case .square: return UIBezierPath(rect: newRect)
        case .rounded(let radius): return UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        }
    }
    
    /// Get inner circle layer
    static func innerCircleActive(rect: CGRect, circle: RadioButtonCircleStyle, style: RadioCheckboxStyle) -> UIBezierPath {
        let size = CGSize(width: circle.inner, height: circle.inner)
        let origon = CGPoint(x: rect.midX-size.width/2, y: rect.midY-size.height/2)
        let newRect = CGRect(origin: origon, size: size)
        switch style {
        case .circle: return UIBezierPath(roundedRect: newRect, cornerRadius: size.height/2)
        case .square: return UIBezierPath(rect: newRect)
        case .rounded(let radius): return UIBezierPath(roundedRect: newRect, cornerRadius: radius)
        }
        
    }
    
    /// Get inner circle layer for inactive state
    static func innerCircleInactive(rect: CGRect) -> UIBezierPath {
        let origin = CGPoint(x: rect.midX, y: rect.midY)
        let frame = CGRect(origin: origin, size: CGSize.zero)
        return UIBezierPath(rect: frame)
    }
    
}
