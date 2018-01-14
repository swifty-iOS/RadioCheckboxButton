//
//  LoadingIndicatorButton.swift
//  RadioButtonDemo
//
//  Created by Manish on 11/01/2018.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

@IBDesignable
public class LoadingIndicatorButton: UIButton {
    
    private weak var loadingIndicator: UIActivityIndicatorView?
    
    @IBInspectable
    public var loadingIndicatorColor: UIColor = UIColor.black
    
    @IBInspectable
    public var enableWhileLoading: Bool = false

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addIndicator()
    }
    
    private func addIndicator() {
        removeIndicator()
        let newIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        newIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        newIndicator.color = loadingIndicatorColor
        addSubview(newIndicator)
        loadingIndicator = newIndicator
     }
    
    private func removeIndicator() {
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
    }
    
   
    public var isLoading: Bool {
      return loadingIndicator?.isAnimating ?? false
    }
    
    public func showLoadingIndicator() {
        addIndicator()
        loadingIndicator?.startAnimating()
        if !enableWhileLoading { isEnabled = false }
    }
    
    public func hideLoadingIndicator() {
        removeIndicator()
        loadingIndicator?.stopAnimating()
        isEnabled = true
    }
}
