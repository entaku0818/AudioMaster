//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import AVFoundation

public class AudioPlayerMaster {
    private var audioPlayer: AVAudioPlayer

    public init(fileName: String) {
        guard let audioFileURL = Bundle.module.url(forResource: fileName, withExtension: "mp3") else {
            fatalError("Audio file not found.")
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer.prepareToPlay()
        } catch {
            fatalError("Error initializing audio player: \(error.localizedDescription)")
        }
    }

    public func playAudio() {
        audioPlayer.play()
    }


    public func pauseAudio() {
        audioPlayer.pause()
    }

    public func stopAudio() {
        audioPlayer.stop()
    }

    public func isPlayngAudio() -> Bool {
        return audioPlayer.isPlaying
    }
}


