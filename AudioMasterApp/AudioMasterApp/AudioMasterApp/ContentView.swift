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
            }
            .navigationBarTitle("Main View", displayMode: .inline)
        }
    }
}

#Preview {
    ContentView()
}
