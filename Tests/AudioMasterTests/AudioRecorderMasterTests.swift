//
//  AudioRecorderMasterTests.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import Foundation
import XCTest
import AVFAudio
@testable import AudioMaster

class AudioRecorderMasterTests: XCTestCase {
    var audioRecorderMaster: AudioRecorderMaster!

    override func setUp() {
        super.setUp()
        let formatID = Int(kAudioFormatLinearPCM)
        let audioQuality = AVAudioQuality.high.rawValue
        let sampleRate = 44100.0
        let numberOfChannels = 2
        let fileName = "audioRecording.wav"

        // AudioRecordingSettingsを作成
        let recordingSettings = AudioRecordingSettings(formatID: formatID, audioQuality: audioQuality, sampleRate: sampleRate, numberOfChannels: numberOfChannels, fileName: fileName)

        // AudioRecorderMasterを初期化
        audioRecorderMaster = AudioRecorderMaster(settings: recordingSettings)
    }

    override func tearDown() {
        audioRecorderMaster = nil
        super.tearDown()
    }

    func testStartRecording() async {
        do {
            let recordingURL = try await audioRecorderMaster.startRecording()
            XCTAssertNotNil(recordingURL)
            print(recordingURL.path)
            XCTAssertTrue(FileManager.default.fileExists(atPath: recordingURL.path))
        } catch {
            XCTFail("Failed to start recording: \(error.localizedDescription)")
        }
    }

    func testStopRecording() async {
        do {
            try await audioRecorderMaster.startRecording()
            try await audioRecorderMaster.stopRecording()
        } catch {
            XCTFail("Failed to stop recording: \(error.localizedDescription)")
        }
    }
}
