//
//  CalculatorBrain.swift
//  CalCo
//
//  Created by Mina Dawood on 25/05/2024.
//

import Foundation

class CalculatorBrainManager {
    
    enum Operator: String, CaseIterable {
        case sum = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
    }
    
    private let operators = Operator.allCases.map({ $0.rawValue })
    
    func addOperator(currentInput: String, operatorSign: String) -> String? {
        if let lastChar = currentInput.last, operators.contains(String(lastChar)) {
            return nil
        }
        return operatorSign
    }
    
    func formatResult(_ result: Double) -> String {
        return result.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(result)) : String(result)
    }
    
    func calculate(userInput: String) -> String {
        let tokens = tokenize(input: userInput)
        let rpn = shuntingYard(tokens: tokens)
        let result = evaluateRPN(rpn: rpn)
        return formatResult(result)
    }
    
    private func tokenize(input: String) -> [String] {
        var tokens: [String] = []
        var numberBuffer: String = ""
        
        for char in input {
            if char.isNumber || char == "." {
                numberBuffer.append(char)
            } else {
                if !numberBuffer.isEmpty {
                    tokens.append(numberBuffer)
                    numberBuffer = ""
                }
                tokens.append(String(char))
            }
        }
        
        if !numberBuffer.isEmpty {
            tokens.append(numberBuffer)
        }
        
        return tokens
    }
    
    private func shuntingYard(tokens: [String]) -> [String] {
        var output: [String] = []
        var operators: [String] = []
        
        let precedence: [String: Int] = [
            "+": 1, "-": 1,
            "*": 2, "/": 2
        ]
        
        for token in tokens {
            if let _ = Double(token) {
                output.append(token)
            } else if let op1 = precedence[token] {
                while let op2 = operators.last, let p2 = precedence[op2], p2 >= op1 {
                    output.append(operators.removeLast())
                }
                operators.append(token)
            }
        }
        
        while let op = operators.popLast() {
            output.append(op)
        }
        
        return output
    }
    
    private func evaluateRPN(rpn: [String]) -> Double {
        var stack: [Double] = []
        
        for token in rpn {
            if let number = Double(token) {
                stack.append(number)
            } else if let b = stack.popLast(), let a = stack.popLast() {
                switch token {
                case "+":
                    stack.append(a + b)
                case "-":
                    stack.append(a - b)
                case "*":
                    stack.append(a * b)
                case "/":
                    stack.append(a / b)
                default:
                    fatalError("Unknown operator: \(token)")
                }
            }
        }
        
        return stack.last ?? 0
    }
}
