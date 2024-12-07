//
//  AudioSessionDemoView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/12/07.
//

import Foundation
import SwiftUI
import AVFoundation

struct AudioSessionDemoView: View {
    @StateObject private var audioManager = AudioSessionController.shared
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    let audioConfigs: [(title: String, action: () -> Void)] = [
        ("バックグラウンド再生", { AudioSessionController.shared.configureBackgroundPlayback() }),
        ("他アプリと同時再生", { AudioSessionController.shared.configureMixWithOthers() }),
        ("録音テスト", { AudioSessionController.shared.configureRecording() }),
        ("通知音テスト", { AudioSessionController.shared.configureNotificationSound() }),
        ("ゲームサウンドテスト", { AudioSessionController.shared.configureGameSound() }),
        ("ビデオ会議テスト", { AudioSessionController.shared.configureVideoConference() }),
        ("ポッドキャストテスト", { AudioSessionController.shared.configurePodcast() }),
        ("音声メッセージテスト", { AudioSessionController.shared.configureVoiceMessage() }),
        ("読み上げテスト", { AudioSessionController.shared.configureTextToSpeech() })
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(audioConfigs, id: \.title) { config in
                    Button(action: {
                        handleAudioAction(title: config.title, action: config.action)
                    }) {
                        Text(config.title)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Audio Session Demo")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handleAudioAction(title: String, action: () -> Void) {
        action()
        showAlert(title: title, message: getMessageForAction(title))
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    private func getMessageForAction(_ title: String) -> String {
        switch title {
        case "バックグラウンド再生":
            return "ホームに戻って動作確認してください"
        case "他アプリと同時再生":
            return "他のアプリの音声と混ざることを確認してください"
        case "録音テスト":
            return audioManager.isRecording ? "録音を停止しました" : "録音を開始しました"
        case "通知音テスト":
            return "他のアプリの音声を妨げないことを確認してください"
        case "ゲームサウンドテスト":
            return "バックグラウンドで停止することを確認してください"
        case "ビデオ会議テスト":
            return "スピーカーモードとエコーキャンセリングが有効になっています"
        case "ポッドキャストテスト":
            return "AirPlayとBluetoothが利用可能です"
        case "音声メッセージテスト":
            return "近接センサーでのスピーカー切り替えが有効です"
        case "読み上げテスト":
            return "他のアプリの音量が自動的に下がることを確認してください"
        default:
            return "設定を適用しました"
        }
    }
}

struct AudioSessionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSessionDemoView()
    }
}
