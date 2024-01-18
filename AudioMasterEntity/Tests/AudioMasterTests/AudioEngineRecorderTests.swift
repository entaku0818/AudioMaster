//
//  AudioEngineRecorderTests.swift
//
//
//  Created by 遠藤拓弥 on 28.9.2023.
//

import XCTest
@testable import AudioMaster

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
        XCTAssertNoThrow(recordedURL = try recorder.startRecording())

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
}

