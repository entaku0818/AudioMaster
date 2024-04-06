//
//  WhisperKitView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/06.
//

import SwiftUI
import WhisperKit

struct WhisperKitView: View {
    @State private var transcription = "音声をテキストに変換して表示します。"
    @State private var isTranscribing = false

    var body: some View {
        VStack {
            Text(transcription)
                .padding()

            if isTranscribing {
                ProgressView("変換中...")
            } else {
                Button("音声ファイルを変換") {
                    transcribeAudio()
                }
            }
        }
    }

    func transcribeAudio() {
        // バンドルからMP4ファイルのURLを取得
        guard let audioURL = Bundle.main.url(forResource: "whisper_sample", withExtension: "mp3") else {
            transcription = "ファイルが見つかりません。"
            return
        }

        isTranscribing = true

        // 非同期タスクで音声ファイルをテキストに変換
        Task {
            do {
                let whisper = try await WhisperKit()
                if let result = try await whisper.transcribe(audioPath: audioURL.path,decodeOptions:DecodingOptions.init(language: "ja"))?.text {
                    transcription = result
                } else {
                    transcription = "トランスクリプションを取得できませんでした。"
                }
            } catch {
                transcription = "エラーが発生しました: \(error)"
            }
            isTranscribing = false
        }
    }
}


#Preview {
    WhisperKitView()
}
