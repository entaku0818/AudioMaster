import SwiftUI
import AVFAudio

struct AudioSessionTestView: View {
    @StateObject private var audioManager = AudioSessionManager.shared
    @State private var testResult: TestResult = TestResult()
    @State private var isShowingResult = false
    @State private var isTestRunning = false

    struct TestResult {
        var category: String = ""
        var mode: String = ""
        var options: String = ""
        var isSuccess: Bool = false
        var errorMessage: String = ""
        var timestamp: Date = Date()
    }

    // 用途に応じたテスト関数
    func testAmbientVideoChat() {
        isTestRunning = true
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playback, mode: .videoRecording)
            try audioSession.setActive(true)

            // 現在の設定を取得
            let currentCategory = audioSession.category
            let currentMode = audioSession.mode
            let currentOptions = audioSession.categoryOptions

            // テスト結果を保存
            testResult.category = currentCategory.rawValue
            testResult.mode = currentMode.rawValue
            testResult.options = formatOptions(currentOptions)

            // 期待する設定と一致するか確認
            testResult.isSuccess = currentCategory == .playback &&
                        currentMode == .videoRecording

        } catch {
            testResult.isSuccess = false
            testResult.errorMessage = error.localizedDescription
        }

        isTestRunning = false
        isShowingResult = true
    }

    // オプションを読みやすい形式に変換
    private func formatOptions(_ options: AVAudioSession.CategoryOptions) -> String {
        var optionsArray: [String] = []

        if options.contains(.mixWithOthers) { optionsArray.append("mixWithOthers") }
        if options.contains(.duckOthers) { optionsArray.append("duckOthers") }
        if options.contains(.allowBluetooth) { optionsArray.append("allowBluetooth") }
        if options.contains(.allowBluetoothA2DP) { optionsArray.append("allowBluetoothA2DP") }
        if options.contains(.interruptSpokenAudioAndMixWithOthers) {
            optionsArray.append("interruptSpokenAudioAndMixWithOthers")
        }

        return optionsArray.joined(separator: ", ")
    }

    var resultView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: testResult.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(testResult.isSuccess ? .green : .red)
                Text(testResult.isSuccess ? "テスト成功" : "テスト失敗")
                    .font(.headline)
            }

            Divider()

            Group {
                ResultRow(title: "カテゴリー", value: testResult.category)
                ResultRow(title: "モード", value: testResult.mode)
                ResultRow(title: "オプション", value: testResult.options)

                if !testResult.errorMessage.isEmpty {
                    VStack(alignment: .leading) {
                        Text("エラー内容:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(testResult.errorMessage)
                            .foregroundColor(.red)
                            .padding(.vertical, 4)
                    }
                }
            }

            Text("テスト実行時刻: \(testResult.timestamp.formatted())")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // ヘッダー
                VStack {
                    Text("オーディオセッションテスト")
                        .font(.title2)
                        .bold()

                    Text("このテストではビデオチャット用のオーディオ設定が正しく構成されているか確認します")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // テスト実行ボタン
                Button(action: testAmbientVideoChat) {
                    HStack(spacing: 12) {
                        if isTestRunning {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "waveform")
                        }
                        Text(isTestRunning ? "テスト実行中..." : "テストを実行")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isTestRunning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isTestRunning)
                .padding(.horizontal)

                // 結果表示
                if isShowingResult {
                    GroupBox {
                        resultView
                            .padding()
                    }
                    .padding(.horizontal)

                    Button(action: {
                        isShowingResult = false
                        testResult = TestResult()
                    }) {
                        Text("結果をクリア")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

struct ResultRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .padding(.vertical, 4)
        }
    }
}
