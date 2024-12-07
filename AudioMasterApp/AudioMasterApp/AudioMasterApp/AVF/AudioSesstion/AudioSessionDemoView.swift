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
        ("通常のバックグラウンド再生", {
            AudioSessionController.shared.configureStandardPlayback()
        }),
        ("他のアプリを優先して再生", {
            AudioSessionController.shared.configureRespectOtherApps()
        }),
        ("自アプリを優先して再生", {
            AudioSessionController.shared.configurePrioritizeOurAudio()
        }),

        // 特殊な用途の設定テスト
        ("録音テスト", {
            AudioSessionController.shared.configureRecording()
        }),
        ("ゲームサウンドテスト", {
            AudioSessionController.shared.configureGameSound()
        }),
        ("ビデオ会議テスト", {
            AudioSessionController.shared.configureVideoConference()
        }),
        ("ポッドキャストテスト", {
            AudioSessionController.shared.configurePodcast()
        }),
        ("音声メッセージテスト", {
            AudioSessionController.shared.configureVoiceMessage()
        }),
        ("読み上げテスト", {
            AudioSessionController.shared.configureTextToSpeech(
                text: "こんにちは。これはテキスト読み上げのテストです。"
            )
        })
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
        case "通常のバックグラウンド再生":
            return "ホームに戻って音声が継続することを確認してください"
        case "他のアプリを優先して再生":
            return "他のアプリで音声を再生すると、このアプリの音量が自動的に下がります"
        case "自アプリを優先して再生":
            return "このアプリの音声が優先され、他のアプリの音量が自動的に下がります"
        case "録音テスト":
            return audioManager.isRecording ? "録音を停止しました" : "録音を開始しました"
        case "ゲームサウンドテスト":
            return "低遅延の音声再生が有効になっています"
        case "ビデオ会議テスト":
            return "スピーカーモードとエコーキャンセリングが有効になっています"
        case "ポッドキャストテスト":
            return "AirPlayとBluetoothが利用可能です"
        case "音声メッセージテスト":
            return "近接センサーでのスピーカー切り替えが有効です"
        case "読み上げテスト":
            return "音声読み上げを開始します。他のアプリの音量は自動的に下がります"
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
