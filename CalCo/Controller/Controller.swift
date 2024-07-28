//
//  Controller.swift
//  CalCo
//
//  Created by Mina Dawood on 27/07/2024.
//

import UIKit

class Controller {
    
    private let brain = CalculatorBrainManager()
    
    func handleOperatorInput(currentInput: String, operatorSign: String) -> String? {
        return brain.addOperator(currentInput: currentInput, operatorSign: operatorSign)
    }
    
    func calculateResult(userInput: String) -> String {
        return brain.calculate(userInput: userInput)
    }
    
    func calculatePercentage(userInput: String) -> String {
        return brain.calculatePercentage(userInput)
    }
}
