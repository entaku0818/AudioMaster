

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

    /// AVAudioPlayer
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

    public mutating func record() -> Void {
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: getAudioFilrUrl(), settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
        } catch let error {
            print(error)
        }
        audioRecorder.record()
    }

    public func recordStop() -> Void {
        audioRecorder.stop()
    }

    public func getAudioFilrUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")

        return audioUrl
    }


}


