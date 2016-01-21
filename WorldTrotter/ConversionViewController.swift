//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Nicholas Mahlangu on 1/15/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Double? {
        // property observer
        didSet {
            updateCelciusLevel()
        }
    }
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    @IBAction func fahrenheitFieldEditingChange(textField: UITextField) {
        if let text = textField.text, value = Double(text) {
            fahrenheitValue = value
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        // hides the keyboard
        textField.resignFirstResponder()
    }
    
    func updateCelciusLevel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let decimalNumbers = NSCharacterSet.decimalDigitCharacterSet()
        var invalidCharacters: Bool = false
        for c in string.characters {
            if String(c) != "." && "\(c)".rangeOfCharacterFromSet(decimalNumbers) == nil {
                invalidCharacters = true
                break
            }
        }
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(".")
        let replacementTextHasDecimalSeparator = string.rangeOfString(".")
        
        if (existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil) || invalidCharacters != false {
            return false
        }
        else {
            return true
        }
    }
    
    // make app dark gray after 18:00 hours (6 pm)
    override func viewWillAppear(animated: Bool) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        if components.hour >= 18 {
            view.backgroundColor = UIColor.darkGrayColor()
        }
    }
}
