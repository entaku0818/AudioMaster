

import AVFoundation

public struct AudioMaster {
    public private(set) var audioPlayer = AVAudioPlayer()

    public init() {
        let audioUrl:URL = URL(fileURLWithPath: "/Users/endo/AudioMaster/Sources/AudioMaster/20220309 084020.m4a")



        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch {
            print("error")
        }

    }

    public func play(){
        audioPlayer.play()
    }

    public func isPlayng() -> Bool {
        return audioPlayer.isPlaying
    }

}


