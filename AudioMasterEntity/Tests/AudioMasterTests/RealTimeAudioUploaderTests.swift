//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 2024/07/13.
//

import Foundation
import XCTest
import AVFoundation
import Starscream
@testable import AudioMaster

class RealTimeAudioUploaderTests: XCTestCase {
    var realTimeUploader: RealTimeAudioUploader!
    var mockWebSocket: MockWebSocket!

    override func setUp() {
        super.setUp()
        mockWebSocket = MockWebSocket()
        realTimeUploader = RealTimeAudioUploader(webSocket: mockWebSocket)
    }

    override func tearDown() {
        realTimeUploader = nil
        mockWebSocket = nil
        super.tearDown()
    }

    func testAudioDataSentToWebSocket() {
        let expectation = self.expectation(description: "Audio data should be sent to WebSocket")
        mockWebSocket.didSendData = { data in
            XCTAssertGreaterThan(data.count, 0, "Audio data should not be empty")
            expectation.fulfill()
        }

        // ダミーのオーディオバッファを生成
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
        let frameCount = AVAudioFrameCount(1024)
        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount)!
        audioBuffer.frameLength = frameCount

        // オーディオデータを生成
        let bufferPointer = audioBuffer.floatChannelData![0]
        for i in 0..<Int(frameCount) {
            bufferPointer[i] = Float(i) / Float(frameCount)
        }

        realTimeUploader.processAudioBuffer(buffer: audioBuffer)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
