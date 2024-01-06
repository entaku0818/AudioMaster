//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import AVFoundation

public class AudioPlayerMaster {
    private var audioPlayer: AVAudioPlayer

    public var volume: Float  {
        return audioPlayer.volume
    }

    public var isPlaying: Bool  {
        return audioPlayer.isPlaying
    }

    public init(fileName: String) {
        let audioSession = AVAudioSession.sharedInstance()

        guard let audioFileURL = Bundle.module.url(forResource: fileName, withExtension: "mp3") else {
            fatalError("Audio file not found.")
        }

        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
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

    public func setVolume(_ volume: Float, fadeDuration duration: TimeInterval) {
        audioPlayer.setVolume(volume, fadeDuration: duration)
    }
}


