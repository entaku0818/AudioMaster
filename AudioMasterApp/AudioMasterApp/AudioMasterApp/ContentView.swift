import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let destination: AnyView

    init<V: View>(title: String, destination: V) {
        self.title = title
        self.destination = AnyView(destination)
    }
}

struct ContentView: View {
    let menuItems: [MenuItem] = [
        MenuItem(title: "ビデオ通話", destination: AgoraVideoView()),
        MenuItem(title: "アニメーション", destination: AnimateViewControllerWrapper()),
        MenuItem(title: "動画再生", destination: PlayerView()),
        MenuItem(title: "音声合成", destination: AVSpeechSynthesizerView()),
        MenuItem(title: "ビデオ表示", destination: VideoView()),
        MenuItem(title: "ピクチャーインピクチャー", destination: PiPVideoPlayerView()),
        MenuItem(title: "音声認識", destination: WhisperKitView()),
        MenuItem(title: "カメラプレビュー", destination: CameraPreviewContentView()),
        MenuItem(title: "Core Animation", destination: CoreAnimationView()),
        MenuItem(title: "Bluetooth デバイス", destination: BluetoothDevicesView()),
        MenuItem(title: "HDR 動画処理", destination: HDRVideoProcessingView()),
        MenuItem(title: "オーディオ設定", destination: AudioSessionSettingsView()),
        MenuItem(title: "AVAudioSession Test", destination: AudioSessionTestView()),
        MenuItem(title: "AVAudioSession Demo", destination: AudioSessionDemoView())

    ]

    // クレジット情報
      let credits = """
          BGM Credit:
          Title: whisper_sample
          Created by: フリーBGM MOMIZizm MUSiC
          Source: http://momizizm.com/
          License: フリーBGM MOMIZizm MUSiCの利用規約に基づく使用
          """

      var body: some View {
          NavigationView {
              List {
                  // メインメニュー
                  ForEach(menuItems) { item in
                      NavigationLink(destination: item.destination) {
                          HStack {
                              Text(item.title)
                                  .font(.body)
                          }
                      }
                  }

                  // クレジットセクション
                  Section(header: Text("Credits")) {
                      Text(credits)
                          .font(.footnote)
                          .foregroundColor(.secondary)
                  }
              }
              .navigationBarTitle("オーディオマスター", displayMode: .large)
              .listStyle(InsetGroupedListStyle())
          }
      }
}

#Preview {
    ContentView()
}
