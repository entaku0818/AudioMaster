

import AVFoundation

public struct AudioMaster {
    public private(set) var audioPlayer = AVAudioPlayer()
    public private(set) var audioRecorder = AVAudioRecorder()
    public private(set) var audioSession = AVAudioSession.sharedInstance()
    public private(set) var isRecording = false


    public init() {
        let audioUrl:URL = URL(fileURLWithPath: "/Users/endo/AudioMaster/Sources/AudioMaster/20220309 084020.m4a")



        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch {
            print("error")
        }

    }

    public func play() {
        audioPlayer.play()
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


//    public mutating func record(){
//
//        try! audioSession.setCategory(.playAndRecord)
//        try! audioSession.setActive(true)
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 44100,
//            AVNumberOfChannelsKey: 2,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//        audioRecorder = try! AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
//        audioRecorder.record()
//
//    }
//
//    func getAudioFileUrl() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let docsDirect = paths[0]
//        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")
//
//        return audioUrl
//    }
}


