//
//  ViewController.swift
//  CalCo
//
//  Created by Mina Dawood on 25/05/2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var calculationTextField: UILabel!
    @IBOutlet weak var resultTextField: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var calculationPreview: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    let controller = Controller()
    
    // Use this Var as a reference for the user input
    private var currentUserOperationInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        setupButtons(in: buttonsStackView)
    }
    
    func updateView() {
        resultTextField.text = "0" // Set default value for resultTextField
        calculationTextField.text = ""
    }
    
    private func setupButtons(in stackView: UIStackView) {
        for subview in stackView.arrangedSubviews {
            if let button = subview as? CustomButton {
                switch button.titleLabel?.text {
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    button.soundType = .number
                case "+", "-", "*", "/", "%", ".":
                    button.soundType = .number
                case "=":
                    button.soundType = .submit
                case "Ac":
                    button.soundType = .clear
                default:
                    button.soundType = .number // Default sound type for any other button
                }
            } else if let stack = subview as? UIStackView {
                setupButtons(in: stack) // Recursively setup buttons in nested stack views
            }
        }
    }
    
    
    @IBAction func clearAllButtonPressed(_ sender: CustomButton) {
        
        resultTextField.text = "0" // Reset to default value
        currentUserOperationInput = ""
        calculationTextField.text = ""
    }
    
    @IBAction func clearLastInput(_ sender: Any) {
    
        if !currentUserOperationInput.isEmpty {
            currentUserOperationInput.removeLast()
            resultTextField.text = currentUserOperationInput.isEmpty ? "0" : currentUserOperationInput
        }
    }
    
    @IBAction func numberButtonPressed(_ sender: CustomButton) {
        
        guard let buttonText = sender.titleLabel?.text else { return }
        
        // Prevent "0" from being added at the beginning
        if buttonText == "0" && currentUserOperationInput.isEmpty {
            return
        }
        
        currentUserOperationInput += buttonText
        resultTextField.text = currentUserOperationInput
        calculationTextField.text = currentUserOperationInput
    }
    
    @IBAction func operatorButtonPressed(_ sender: CustomButton) {
        
        guard let operatorInput = sender.titleLabel?.text else { return }
        
        if operatorInput == "%" {
            let result = controller.calculatePercentage(userInput: currentUserOperationInput)
            resultTextField.text = result
            currentUserOperationInput = result
            return
        }
        
        if let validOperator = controller.handleOperatorInput(currentInput: currentUserOperationInput, operatorSign: operatorInput) {
            currentUserOperationInput += validOperator
            resultTextField.text = currentUserOperationInput
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: CustomButton) {
        
        let result = controller.calculateResult(userInput: currentUserOperationInput )
        resultTextField.text = result
        currentUserOperationInput = resultTextField.text ?? ""
    }
}
