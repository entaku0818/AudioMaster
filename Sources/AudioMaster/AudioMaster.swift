

import AVFoundation

public struct AudioMaster {
    public private(set) var audioPlayer = AVAudioPlayer()
    public private(set) var audioRecorder = AVAudioRecorder()
    public private(set) var isRecording = false


    public init(url:URL) {


        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }

    }

    public func play() {
        audioPlayer.play()
    }

    public func stop() {
        audioPlayer.stop()
    }

    public func isPlayng() -> Bool {
        return audioPlayer.isPlaying
    }

    public func setVolume(volume:Float){
        audioPlayer.volume = volume
    }

    public func volume() -> Float{
        return audioPlayer.volume
    }


}


