//
//  AudioRecorderMaster.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import AVFoundation

public struct AudioRecordingSettings {
    let formatID: Int
    let audioQuality: Int
    let sampleRate: Double
    let numberOfChannels: Int

    public init(formatID: Int, audioQuality: Int, sampleRate: Double, numberOfChannels: Int) {
        self.formatID = formatID
        self.audioQuality = audioQuality
        self.sampleRate = sampleRate
        self.numberOfChannels = numberOfChannels
    }

    public func asDictionary() -> [String: Any] {
        return [
            AVFormatIDKey: formatID,
            AVEncoderAudioQualityKey: audioQuality,
            AVSampleRateKey: sampleRate,
            AVNumberOfChannelsKey: numberOfChannels
        ]
    }
}

public class AudioRecorderMaster: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?
    private let settings: AudioRecordingSettings

    public init(settings: AudioRecordingSettings) {
        self.settings = settings
        super.init()
    }

    public func startRecording() async throws -> URL {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
            throw error
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let recordingName = "audioRecording.wav"
        recordingURL = documentsDirectory.appendingPathComponent(recordingName)

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, settings: settings.asDictionary())
            audioRecorder?.record()
        } catch {
            print("Error starting audio recording: \(error.localizedDescription)")
            throw error
        }

        return recordingURL!
    }

    public func stopRecording() async throws {
        audioRecorder?.stop()
    }
}
