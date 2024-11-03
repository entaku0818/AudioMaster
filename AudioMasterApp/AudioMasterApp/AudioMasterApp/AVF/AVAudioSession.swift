import SwiftUI
import AVFoundation

class AudioSessionManager: ObservableObject {
    static let shared = AudioSessionManager()

    @Published var isAudioSessionActive = false
    @Published var currentMode: AVAudioSession.Mode = .default
    @Published var currentCategory: AVAudioSession.Category = .playback
    @Published var currentOptions: AVAudioSession.CategoryOptions = []

    // カテゴリの定義と説明
    let availableCategories: [(category: AVAudioSession.Category, description: String)] = [
        (.ambient, "他のアプリの音声と混ざって再生。サイレントモードで無音"),
        (.soloAmbient, "他のアプリの音声を中断。サイレントモードで無音"),
        (.playback, "バックグラウンド再生可能。サイレントモードでも再生"),
        (.record, "録音専用。他アプリの音声を中断"),
        (.playAndRecord, "録音と再生が可能。VoIPなどに使用"),
        (.multiRoute, "複数のオーディオ経路での入出力が可能")
    ]

    // カテゴリオプションの定義と説明
    let availableOptions: [(option: AVAudioSession.CategoryOptions, description: String)] = [
        (.mixWithOthers, "他のアプリの音声との混合を許可"),
        (.duckOthers, "他のアプリの音量を自動的に低下"),
        (.interruptSpokenAudioAndMixWithOthers, "他のアプリの音声コンテンツを中断して混合"),
        (.allowBluetooth, "Bluetoothヘッドセット(HFP/HSP)の使用を許可"),
        (.allowBluetoothA2DP, "Bluetoothステレオ音声(A2DP)の使用を許可"),
        (.allowAirPlay, "AirPlayデバイスの使用を許可"),
        (.defaultToSpeaker, "内蔵スピーカーを優先使用")
    ]

    // モードの定義（前回と同じ）
    let availableModes: [(mode: AVAudioSession.Mode, description: String)] = [
        (.default, "デフォルトモード - 一般的な音声再生に使用"),
        (.moviePlayback, "動画再生 - 映画やビデオコンテンツの再生に最適化"),
        (.videoRecording, "ビデオ録画 - カメラアプリなどでの録画に使用"),
        (.voiceChat, "ボイスチャット - 通話やボイスチャットに最適化"),
        (.gameChat, "ゲームチャット - ゲーム中の音声チャットに最適化"),
        (.videoChat, "ビデオチャット - ビデオ通話に最適化"),
        (.measurement, "測定 - オーディオ入力の正確な測定に使用"),
        (.spokenAudio, "音声オーディオ - ポッドキャストや朗読などに最適化")
    ]

    // 各カテゴリで利用可能なオプションを返す
    func getAvailableOptionsForCategory(_ category: AVAudioSession.Category) -> [AVAudioSession.CategoryOptions] {
        switch category {
        case .ambient, .soloAmbient:
            return [.mixWithOthers]
        case .playback:
            return [.mixWithOthers, .duckOthers, .interruptSpokenAudioAndMixWithOthers,
                   .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
        case .playAndRecord:
            return [.mixWithOthers, .duckOthers, .defaultToSpeaker,
                   .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
        case .record:
            return [.defaultToSpeaker]
        case .multiRoute:
            return [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
        default:
            return []
        }
    }

    func configureAudioSession(withCategory category: AVAudioSession.Category,
                             mode: AVAudioSession.Mode,
                             options: AVAudioSession.CategoryOptions = []) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // カテゴリ、モード、オプションを設定
            try audioSession.setCategory(category, mode: mode, options: options)
            try audioSession.setActive(true, options: [])

            // カテゴリとモードに応じた最適な設定
            switch (category, mode) {
            case (.playback, .moviePlayback), (.playAndRecord, .videoChat):
                try audioSession.setPreferredSampleRate(48000.0)
                try audioSession.setPreferredIOBufferDuration(0.005)
            case (.record, .videoRecording):
                try audioSession.setPreferredSampleRate(96000.0)
                try audioSession.setPreferredIOBufferDuration(0.001)
            default:
                try audioSession.setPreferredSampleRate(44100.0)
                try audioSession.setPreferredIOBufferDuration(0.005)
            }

            currentCategory = category
            currentMode = mode
            currentOptions = options
            isAudioSessionActive = true

        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
            isAudioSessionActive = false
        }
    }

    // プリセット設定
    func applyPreset(_ preset: AudioSessionPreset) {
        switch preset {
        case .musicPlayer:
            configureAudioSession(
                withCategory: .playback,
                mode: .default,
                options: [.allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
            )
        case .videoCall:
            configureAudioSession(
                withCategory: .playAndRecord,
                mode: .videoChat,
                options: [.allowBluetooth, .defaultToSpeaker, .mixWithOthers]
            )
        case .voiceRecorder:
            configureAudioSession(
                withCategory: .record,
                mode: .default,
                options: [.defaultToSpeaker]
            )
        case .game:
            configureAudioSession(
                withCategory: .ambient,
                mode: .gameChat,
                options: [.mixWithOthers]
            )
        }
    }

    func getCurrentConfiguration() -> String {
        let audioSession = AVAudioSession.sharedInstance()
        var config = """
        カテゴリ: \(currentCategory.rawValue)
        モード: \(currentMode.rawValue)
        サンプルレート: \(audioSession.sampleRate) Hz
        バッファ時間: \(audioSession.ioBufferDuration) 秒
        入力利用可能: \(audioSession.isInputAvailable)
        """

        if !currentOptions.isEmpty {
            config += "\n有効なオプション:"
            if currentOptions.contains(.mixWithOthers) { config += "\n- 他アプリとの混合" }
            if currentOptions.contains(.duckOthers) { config += "\n- 他アプリの音量を低下" }
            if currentOptions.contains(.defaultToSpeaker) { config += "\n- スピーカー優先" }
            if currentOptions.contains(.allowBluetooth) { config += "\n- Bluetooth対応" }
            if currentOptions.contains(.allowBluetoothA2DP) { config += "\n- BluetoothA2DP対応" }
            if currentOptions.contains(.allowAirPlay) { config += "\n- AirPlay対応" }
        }

        return config
    }
}

// プリセット定義
enum AudioSessionPreset {
    case musicPlayer
    case videoCall
    case voiceRecorder
    case game
}

struct AudioSessionSettingsView: View {
    @StateObject private var audioManager = AudioSessionManager.shared
    @State private var showSettings = false
    @State private var selectedCategory: AVAudioSession.Category = .playback
    @State private var selectedMode: AVAudioSession.Mode = .default
    @State private var selectedOptions: AVAudioSession.CategoryOptions = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Audio Session 設定")
                    .font(.title)
                    .padding()

                // プリセット選択
                GroupBox(label: Text("プリセット")) {
                    VStack(spacing: 10) {
                        ForEach([
                            ("Music Player", AudioSessionPreset.musicPlayer),
                            ("Video Call", AudioSessionPreset.videoCall),
                            ("Voice Recorder", AudioSessionPreset.voiceRecorder),
                            ("Game", AudioSessionPreset.game)
                        ], id: \.0) { preset in
                            Button(action: {
                                audioManager.applyPreset(preset.1)
                                showSettings = true
                            }) {
                                Text(preset.0)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }

                // カテゴリ選択セクション
                GroupBox(label: Text("カテゴリ選択")) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(audioManager.availableCategories, id: \.category.rawValue) { categoryInfo in
                                CategorySelectionRow(
                                    categoryInfo: categoryInfo,
                                    isSelected: audioManager.currentCategory == categoryInfo.category,
                                    action: {
                                        selectedCategory = categoryInfo.category
                                        selectedOptions = []
                                        audioManager.configureAudioSession(
                                            withCategory: categoryInfo.category,
                                            mode: selectedMode,
                                            options: selectedOptions
                                        )
                                        showSettings = true
                                    }
                                )
                            }
                        }
                    }
                    .frame(height: 200)
                }

                // オプション選択セクション
                GroupBox(label: Text("利用可能なオプション")) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(audioManager.availableOptions.filter { audioManager.getAvailableOptionsForCategory(selectedCategory).contains($0.option) },
                                   id: \.option.rawValue) { optionInfo in
                                OptionToggleRow(
                                    optionInfo: optionInfo,
                                    isSelected: selectedOptions.contains(optionInfo.option),
                                    action: { isSelected in
                                        if isSelected {
                                            selectedOptions.insert(optionInfo.option)
                                        } else {
                                            selectedOptions.remove(optionInfo.option)
                                        }
                                        audioManager.configureAudioSession(
                                            withCategory: selectedCategory,
                                            mode: selectedMode,
                                            options: selectedOptions
                                        )
                                    }
                                )
                            }
                        }
                    }
                    .frame(height: 150)
                }


                // 現在の設定表示
                if showSettings {
                    GroupBox(label: Text("現在の設定")) {
                        Text(audioManager.getCurrentConfiguration())
                            .font(.system(.body, design: .monospaced))
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
}

struct CategorySelectionRow: View {
    let categoryInfo: (category: AVAudioSession.Category, description: String)
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                HStack {
                    Text(categoryInfo.category.rawValue)
                        .fontWeight(.bold)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                Text(categoryInfo.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
        }
    }
}

struct OptionToggleRow: View {
    let optionInfo: (option: AVAudioSession.CategoryOptions, description: String)
    let isSelected: Bool
    let action: (Bool) -> Void

    var body: some View {
        Toggle(isOn: Binding(
            get: { isSelected },
            set: { action($0) }
        )) {
            VStack(alignment: .leading) {
                Text(optionInfo.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 2)
    }
}

struct AudioSessionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSessionSettingsView()
    }
}
