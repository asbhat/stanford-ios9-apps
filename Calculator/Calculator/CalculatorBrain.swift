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
    
    private var accumulator: (text: String?, value: Double) = (nil, 0.0)
    private var internalProgram = [AnyObject]()
    
    var description = ""
    
    var isPartialResult : Bool {
        get {
            return pending != nil
        }
    }
    
    private let descriptionFormatter = NumberFormatter()
    
    private var formattedAccumulator: String {
        get {
            descriptionFormatter.maximumFractionDigits = (accumulator.value).truncatingRemainder(dividingBy: 1) == 0 ? 0 : 4
            return accumulator.text ?? descriptionFormatter.string(from: NSNumber(value: accumulator.value))!
        }
    }
    
    private var descriptionStillRelevant = true
    private var binaryTermInDescription = false
    
    func enter(operand: Double) {
        accumulator = (nil, operand)
        internalProgram.append(operand as AnyObject)
        descriptionStillRelevant = isPartialResult ? true : false
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "rand": Operation.nullaryOperation({ drand48() }),
        "x²" : Operation.unaryOperation({ pow($0, 2) }),
        "±" : Operation.unaryOperation({ -$0 }),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "%" : Operation.unaryOperation({ $0 / 100.0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),  // this is a closure
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals
    ]
    
    // enums are passed by value (not refernce)
    // Optional is an enum with associated values
    private enum Operation {
        case constant(Double)
        case nullaryOperation(() -> Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (symbol, value)
            case .nullaryOperation(let function):
                accumulator = (symbol + "()", function())
            case .unaryOperation(let function):
                if isPartialResult {
                    description += "\(symbol)(\(formattedAccumulator)) "
                    binaryTermInDescription = true
                } else {
                    if description == "" {
                        description = "\(formattedAccumulator)"
                    }
                    description = "\(symbol)(\(description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))) "
                }
                accumulator = (symbol, function(accumulator.value))
            case .binaryOperation(let function):
                executePendingBinaryOperation()
                if !descriptionStillRelevant {
                    description = "\(formattedAccumulator) \(symbol) "
                } else if binaryTermInDescription {
                    description += "\(symbol) "
                } else {
                    description += "\(formattedAccumulator) \(symbol) "
                }
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator.value)
                binaryTermInDescription = false
            case .equals:
                executePendingBinaryOperation()
                binaryTermInDescription = true
            }
        }
    }
    
    private func updateDescription(symbol: String = "") {
        if !descriptionStillRelevant {
            description = formattedAccumulator + symbol + " "
        } else if binaryTermInDescription {
            description += formattedAccumulator + " "
        } else if isPartialResult {
            description += symbol + formattedAccumulator + " "
        } else {
            description += formattedAccumulator + " "
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            if !binaryTermInDescription {
                description += "\(formattedAccumulator) "
                binaryTermInDescription = true
            }
            accumulator.value = pending!.binaryFunction(pending!.firstOperand, accumulator.value)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    // structs are also always passed by value
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            allClear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        enter(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    var result: Double {
        // read-only computed properly
        get {
            return accumulator.value
        }
    }
    
    func allClear() {
        accumulator = (nil, 0.0)
        description = ""
        pending = nil
        internalProgram.removeAll()
    }
    
}
