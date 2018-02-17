//
//  CheckboxSampleViewController.swift
//  RadioAndCheckboxButtonDemo
//
//  Created by Manish Bhande on 12/02/18.
//  Copyright © 2018 Manish. All rights reserved.
//

import UIKit

class CheckboxSampleViewController: UIViewController {
    
    @IBOutlet weak var viewGroup2: CheckboxButtonContainerView!
    
    @IBOutlet weak var optionAG3: CheckboxButton!
    @IBOutlet weak var optionBG3: CheckboxButton!
    @IBOutlet weak var optionCG3: CheckboxButton!
    
    var group3Container = CheckboxButtonContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroup2()
        setupGroup3()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGroup2() {
        viewGroup2.buttonContainer.delegate = self
        viewGroup2.buttonContainer.setEachCheckboxButtonColor {
            return CheckBoxColor(activeColor: $0.tintColor, inactiveColor: UIColor.clear, inactiveBorderColor: $0.tintColor, checkMarkColor: UIColor.white)
        }
    }
    
    func setupGroup3() {
        group3Container.addButtons([optionAG3, optionBG3, optionCG3])
        group3Container.delegate = self
        
        group3Container.selectedButtons = [optionBG3]
        
        // set style, color and border for option A
        optionAG3.style = .square
        optionAG3.checkBoxColor = CheckBoxColor(activeColor: UIColor.clear, inactiveColor: UIColor.red, inactiveBorderColor: UIColor.red, checkMarkColor: UIColor.magenta)
        optionAG3.checkboxLine = CheckboxLineStyle(checkBoxHeight: 25)
        
        // set style, color for option B
        optionBG3.style = .circle
        optionBG3.checkBoxColor = CheckBoxColor(activeColor: UIColor.brown, inactiveColor: UIColor.yellow, inactiveBorderColor: UIColor.blue, checkMarkColor: UIColor.black)
        
        // set border for option C
        optionCG3.checkboxLine = CheckboxLineStyle(checkBoxHeight: 35, checkmarkLineWidth: 7, padding: 15)
        optionCG3.checkBoxColor = CheckBoxColor(activeColor: UIColor.white, inactiveColor: UIColor.white, inactiveBorderColor: UIColor.white, checkMarkColor: optionCG3.tintColor)
    }
    
}

extension CheckboxSampleViewController: CheckboxButtonDelegate {
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        print("Select: ", button.title(for: .normal)!)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        print("Deselect: ", button.title(for: .normal)!)
    }
    
    
}
