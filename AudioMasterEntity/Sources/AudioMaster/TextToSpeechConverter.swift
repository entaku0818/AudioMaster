//
//  AVSpeechSynthesizer.swift
//
//
//  Created by 遠藤拓弥 on 2024/03/10.
//

import Foundation
import AVFoundation

public class TextToSpeechConverter {
    let speechSynthesizer:AVSpeechSynthesizer

    public init() {
        speechSynthesizer = AVSpeechSynthesizer()
    }

    // 早口で話す
    public func speakFast(text: String, language: String = "ja-JP") {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechSynthesizer.speak(speechUtterance)
    }

    // ゆっくり話す
    public func speakSlow(text: String, language: String = "ja-JP") {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        speechUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechSynthesizer.speak(speechUtterance)
    }

    // 高いピッチで話す
    public func speakHighPitch(text: String, language: String = "ja-JP") {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 2.0
        speechUtterance.volume = 1.0
        speechSynthesizer.speak(speechUtterance)
    }

    // 低いピッチで話す
    public func speakLowPitch(text: String, language: String = "ja-JP") {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 0.5
        speechUtterance.volume = 1.0
        speechSynthesizer.speak(speechUtterance)
    }

    // 通常の話し方
    public func speakNormal(text: String, language: String = "ja-JP") {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechSynthesizer.speak(speechUtterance)
    }
}

