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

    func startRecording() throws -> URL {
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
            let format = audioEngine.inputNode.outputFormat(forBus: 0)
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
