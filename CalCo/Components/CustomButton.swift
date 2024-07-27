//
//  CustomButton.swift
//  CalCo
//
//  Created by Mina Dawood on 25/05/2024.
//

import UIKit
import AVFoundation

enum SoundType {
    case number
    case operatorSound
    case submit
    case clear
}

class CustomButton: UIButton {
    
    var soundType: SoundType?
    private var audioPlayer: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        animateButtonPress()
        playSound()
    }
    
    private func animateButtonPress() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
    
    private func playSound() {
        guard let soundType = soundType else {
            print("SoundType not set")
            return
        }
        
        let soundFileName: String
        
        switch soundType {
        case .number:
            soundFileName = "NumberSound"
        case .operatorSound:
            soundFileName = "NumberSound"
        case .submit:
            soundFileName = "submitSound"
        case .clear:
            soundFileName = "ClearSound"
        }
        
        print("Playing sound: \(soundFileName)")
        
        if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Unable to play sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found: \(soundFileName).wav")
        }
    }
}
