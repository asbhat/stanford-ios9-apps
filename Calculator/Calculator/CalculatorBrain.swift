//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Aditya Bhat on 5/26/2016.
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


import Foundation

class CalculatorBrain {
    
    func setOperand(operand: Double) { }
    
    func performOperation(symbol: String) { }
    
    var result: Double {
        // read-only computed properly
        get {
            return 0.0
        }
    }
    
}