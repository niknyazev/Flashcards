//
//  SpeechSynthesizer.swift
//  Flashcards
//
//  Created by Николай on 21.01.2022.
//

import Foundation
import AVFoundation

final class SpeechSynthesizer {
    
    static let shared = SpeechSynthesizer()
    
    private init() { }
    
    func pronounce(text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
    
}

