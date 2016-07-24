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
    
    private var accumulator = 0.0
    
    var description = ""
    
    var isPartialResult : Bool {
        get {
            return pending != nil
        }
    }
    
    private let descriptionFormatter = NSNumberFormatter()
    
    var formattedAccumulator: String {
        get {
            descriptionFormatter.maximumFractionDigits = accumulator % 1 == 0 ? 0 : 4
            return descriptionFormatter.stringFromNumber(accumulator)!
        }
    }
    
    private var descriptionStillRelevant = true
    private var binaryTermInDescription = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        descriptionStillRelevant = isPartialResult ? true : false
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "x²" : Operation.UnaryOperation({ pow($0, 2) }),
        "±" : Operation.UnaryOperation({ -$0 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "%" : Operation.UnaryOperation({ $0 / 100.0 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),  // this is a closure
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    // enums are passed by value (not refernce)
    // Optional is an enum with associated values
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                description += "\(symbol) "
                binaryTermInDescription = true
            case .UnaryOperation(let function):
                if isPartialResult {
                    description += "\(symbol)(\(formattedAccumulator)) "
                    binaryTermInDescription = true
                } else {
                    if description == "" {
                        description = "\(formattedAccumulator)"
                    }
                    description = "\(symbol)(\(description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))) "
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                if !descriptionStillRelevant {
                    description = "\(formattedAccumulator) \(symbol) "
                } else if binaryTermInDescription {
                    description += "\(symbol) "
                } else {
                    description += "\(formattedAccumulator) \(symbol) "
                }
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                binaryTermInDescription = false
            case .Equals:
                executePendingBinaryOperation()
                binaryTermInDescription = true
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            if !binaryTermInDescription {
                description += "\(formattedAccumulator) "
                binaryTermInDescription = true
            }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    // structs are also always passed by value
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        // read-only computed properly
        get {
            return accumulator
        }
    }
    
    func allClear() {
        accumulator = 0.0
        description = ""
        pending = nil
    }
    
}
