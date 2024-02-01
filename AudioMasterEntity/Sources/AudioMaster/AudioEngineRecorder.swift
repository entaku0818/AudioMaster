//
//  AudioEngineRecorder.swift
//
//
//  Created by 遠藤拓弥 on 28.9.2023.
//

import Foundation
import AVFoundation

class AudioEngineRecorder: NSObject {

    private var audioEngine = AVAudioEngine()
    private var audioFile: AVAudioFile?
    private var recordingURL: URL?

    override init() {
        super.init()
    }

    public enum AudioQuality {
        case high
        case standard
    }

    func startRecording(withQuality quality: AudioQuality) throws -> URL {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.record, mode: .voicePrompt, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
            throw error
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let recordingName = "audioRecording.caf"
        recordingURL = documentsDirectory.appendingPathComponent(recordingName)

        do {
            let desiredSampleRate: Double
            let channelCount: AVAudioChannelCount
            let settings: [String: Any]

            // 高品質と標準品質の設定
            switch quality {
            case .high:
                // 高品質の設定
                desiredSampleRate = 48000.0  // 48kHz
                channelCount = 2             // ステレオ
                settings = [
                    AVFormatIDKey: kAudioFormatLinearPCM,
                    AVSampleRateKey: desiredSampleRate,
                    AVNumberOfChannelsKey: channelCount,
                    AVLinearPCMBitDepthKey: 24,
                    AVLinearPCMIsFloatKey: false,
                    AVLinearPCMIsBigEndianKey: false
                ]

                try audioSession.setPreferredSampleRate(desiredSampleRate)
                try audioSession.setPreferredIOBufferDuration(1024.0 / desiredSampleRate)

            case .standard:
                // 標準品質の設定
                let format = audioEngine.inputNode.outputFormat(forBus: 0)
                desiredSampleRate = format.sampleRate
                channelCount = format.channelCount
                settings = format.settings
            }

            let format = AVAudioFormat(settings: settings) ?? audioEngine.inputNode.outputFormat(forBus: 0)
            audioFile = try AVAudioFile(forWriting: recordingURL!, settings: format.settings)

            audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, time) in
                do {
                    try self.audioFile?.write(from: buffer)
                } catch {
                    print("Error writing to audio file: \(error.localizedDescription)")
                }
            }
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
            throw error
        }

        return recordingURL!
    }

    func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
