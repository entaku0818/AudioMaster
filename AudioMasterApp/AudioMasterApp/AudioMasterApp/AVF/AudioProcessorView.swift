//
//  AudioProcessorView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/03/23.
//

import Foundation
import SwiftUI

struct AudioProcessorView: View {
    @StateObject private var viewModel = AudioProcessorViewModel()

    var body: some View {
        VStack {
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
            }
            .padding()
            .background(viewModel.isRecording ? Color.red : Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())

            Button(action: {
                viewModel.togglePlayback()
            }) {
                Text(viewModel.isPlaying ? "Stop Playback" : "Start Playback")
            }
            .padding()
            .background(viewModel.isPlaying ? Color.green : Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
