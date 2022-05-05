

import AVFoundation


public struct AudioMaster {
    public private(set) var audioPlayer = AVAudioPlayer()
    public private(set) var audioRecorder = AVAudioRecorder()
    public private(set) var isRecording = false
    private var audioFileUrl:URL?


    public init(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }
    }

    /// AVAudioPlayer Method
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

    /// AudioRecorder Method
    public mutating func recordStart() -> Void {
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.record, mode: .default)
            try session.setActive(true)

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]


            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            audioFileUrl = getAudioFileUrl()
        } catch let error {
            print(error)
        }
        audioRecorder.record()
    }

    public func recordStop() -> Void {
        audioRecorder.stop()
    }

    public func lastRecordAudioFile() -> URL? {
        audioFileUrl
    }

    private func getAudioFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording\(DateFormatter.yyyyMMddHHmmss.string(from: Date())).m4a")

        return audioUrl
    }


}


