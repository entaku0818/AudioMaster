//
//  AudioProcessorViewModel.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/03/23.
//

import Foundation
import SwiftUI
import AudioMaster

class AudioProcessorViewModel: ObservableObject {
    private var audioProcessor: AudioProcessor?

    @Published var isRecording = false
    @Published var isPlaying = false

    init() {
        audioProcessor = AudioProcessor()
    }

    func toggleRecording() {
        if isRecording {
            audioProcessor?.stopRecording()
        } else {
            audioProcessor?.startRecording()
        }
        isRecording.toggle()
    }

    func togglePlayback() {
        if isPlaying {
            audioProcessor?.stopPlayback()
        } else {
            audioProcessor?.startPlayback()
        }
        isPlaying.toggle()
    }
}
