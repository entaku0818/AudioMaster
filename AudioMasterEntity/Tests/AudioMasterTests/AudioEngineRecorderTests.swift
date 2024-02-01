//
//  AudioEngineRecorderTests.swift
//
//
//  Created by 遠藤拓弥 on 28.9.2023.
//

import XCTest
@testable import AudioMaster
import AVFAudio

class AudioEngineRecorderTests: XCTestCase {

    var recorder: AudioEngineRecorder!

    override func setUp() {
        super.setUp()
        recorder = AudioEngineRecorder()
    }

    override func tearDown() {
        recorder = nil
        super.tearDown()
    }

    func testRecording() {
        // 録音を開始
        var recordedURL: URL?
        XCTAssertNoThrow(recordedURL = try recorder.startRecording(withQuality: .standard))

        // 少しの間、録音を続ける
        Thread.sleep(forTimeInterval: 2.0)

        // 録音を停止
        recorder.stopRecording()

        // 録音ファイルが正しく生成されているか確認
        if let url = recordedURL {
            var isDirectory: ObjCBool = false
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory))
            XCTAssertFalse(isDirectory.boolValue)
        } else {
            XCTFail("Recording URL should not be nil")
        }
    }

    func testHighQualityRecording() {
        do {
            // 高品質設定で録音を開始
            let recordingURL = try recorder.startRecording(withQuality: .high)

            // 期待されるオーディオ設定を確認
            let audioFile = try AVAudioFile(forReading: recordingURL)
            let format = audioFile.processingFormat
            let settings = format.settings

            // サンプルレートの検証
            XCTAssertEqual(settings[AVSampleRateKey] as? Double, 48000.0)

            // チャネル数の検証
            XCTAssertEqual(format.channelCount, 2)


        } catch {
            XCTFail("録音の開始に失敗しました: \(error)")
        }
    }
}

