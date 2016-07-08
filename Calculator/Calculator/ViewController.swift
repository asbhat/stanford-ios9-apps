//
//  ViewController.swift
//  Calculator
//
//  Created by Aditya Bhat on 5/2/2016.
//  Copyright © 2016 Aditya Bhat. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


import UIKit

class ViewController: UIViewController {
    
    // implicitly (automatically) unwraps display
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var history: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != "." || textCurrentlyInDisplay.rangeOfString(".") == nil {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = (digit == "." ? "0." : digit)
        }
        userIsInTheMiddleOfTyping = true
    }
    
    // computed propery
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    // initializing CalculatorBrain with the default initializer (takes no arguments)
    private var brain = CalculatorBrain()
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        history.text = brain.description + (brain.isPartialResult ? "..." : "=")
    }
    
    @IBAction private func allClear() {
        displayValue = 0
        history.text = " "
        userIsInTheMiddleOfTyping = false
        brain.allClear()
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddleOfTyping {
            if display.text!.characters.count > 1 {
                display.text!.removeAtIndex(display.text!.endIndex.predecessor())
            } else {
                displayValue = 0
                userIsInTheMiddleOfTyping = false
            }
        }
    }
}
