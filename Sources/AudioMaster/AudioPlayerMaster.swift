//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import AVFoundation

public class AudioPlayerMaster {
    private var audioPlayer: AVAudioPlayer?
    public private(set) var isPlaying: Bool = false

    public init() { }

    public func playAudioFromFile(named fileName: String) {

        guard let audioFileURL = Bundle.module.url(forResource: fileName, withExtension: "mp3") else {
            print("Audio file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }

    public func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false 
    }
}


