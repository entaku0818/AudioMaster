//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import AVFoundation
import AVFoundation

@available(iOS 13.0.0, *)
public class AudioRecorderMaster: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?

    public override init() {
        super.init()
    }

    public func startRecording() async throws -> URL {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try await audioSession.setCategory(.record, mode: .default, options: [])
            try await audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
            throw error
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let recordingName = "audioRecording.wav"
        recordingURL = documentsDirectory.appendingPathComponent(recordingName)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, settings: settings)
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
