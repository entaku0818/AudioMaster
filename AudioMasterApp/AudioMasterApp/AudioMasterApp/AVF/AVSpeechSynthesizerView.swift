//
//  AVSpeechSynthesizer.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/03/10.
//

import Foundation
import SwiftUI
import AVFoundation
import AudioMaster

struct AVSpeechSynthesizerView: View {
    private let speechConverter = TextToSpeechConverter()

    var body: some View {
        VStack(spacing: 20) {
            Button("早口で話す") {
                speechConverter.speakFast(text: "こんにちは、世界！")
            }

            Button("ゆっくり話す") {
                speechConverter.speakSlow(text: "今日はいい天気ですね。")
            }

            Button("高いピッチで話す") {
                speechConverter.speakHighPitch(text: "何をして遊びますか？")
            }

            Button("低いピッチで話す") {
                speechConverter.speakLowPitch(text: "昨日は遅くまで起きていました。")
            }

            Button("通常の話し方") {
                speechConverter.speakNormal(text: "このアプリは音声合成をサポートしています。")
            }
        }
    }
}
