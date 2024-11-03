//
//  ContentView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/01/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AgoraVideoView()) {
                    Text("Show Video Call")
                }
                NavigationLink(destination: AnimateViewControllerWrapper()) {
                    Text("Show Animation")
                }


                NavigationLink(destination:  PlayerView()) {
                    Text("Show Move")
                }
                NavigationLink(destination:  AVSpeechSynthesizerView()) {
                    Text("Show AVSpeechSynthesizer")
                }
                NavigationLink(destination:  VideoView()) {
                    Text("Show VideoView")
                }

                NavigationLink(destination:  PiPVideoPlayerView()) {
                    Text("Show PiPVideoPlayerView")
                }
                NavigationLink(destination:  WhisperKitView()) {
                    Text("Show WhisperKitView")
                }
                NavigationLink(destination:  CameraPreviewContentView()) {
                    Text("Show CameraPreviewContentView")
                }

                NavigationLink(destination:  CoreAnimationView()) {
                    Text("Show CoreAnimationView")
                }

                NavigationLink(destination:  BluetoothDevicesView()) {
                    Text("Show BluetoothDevicesView")
                }
                NavigationLink(destination:  HDRVideoProcessingView()) {
                    Text("Show HDRVideoProcessingView")
                }
                NavigationLink("Audio Settings") {
                    AudioSessionSettingsView()
                }
                NavigationLink("Test Audio Settings") {
                    AudioSessionTestView()
                }
            }
            .navigationBarTitle("Main View", displayMode: .inline)
        }
    }
}

#Preview {
    ContentView()
}
