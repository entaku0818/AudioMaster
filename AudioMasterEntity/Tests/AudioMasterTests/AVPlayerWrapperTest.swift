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

class AVPlayerWrapperTests: XCTestCase {

    var playerWrapper: AVPlayerWrapper!
    var mockURL: URL!

    override func setUp() {
        super.setUp()
        // テスト用のURLを作成（実際のオーディオファイルは不要）
        mockURL = URL(string: "https://example.com/audio.mp3")!
        playerWrapper = AVPlayerWrapper(url: mockURL)
    }

    override func tearDown() {
        playerWrapper = nil
        mockURL = nil
        super.tearDown()
    }

    func testPlay() {
        playerWrapper.play()
        XCTAssertTrue(playerWrapper.isPlaying)
    }

    func testPause() {
        playerWrapper.play()
        playerWrapper.pause()
        XCTAssertFalse(playerWrapper.isPlaying)
    }

    func testStop() {
        playerWrapper.play()
        playerWrapper.stop()
        XCTAssertFalse(playerWrapper.isPlaying)
        XCTAssertEqual(playerWrapper.currentTime, CMTime.zero)
    }

    func testVolume() {
        let expectedVolume: Float = 0.5
        playerWrapper.volume = expectedVolume
        XCTAssertEqual(playerWrapper.volume, expectedVolume)
    }

    func testSeek() {
        let seekTime = CMTime(seconds: 10, preferredTimescale: 1)
        playerWrapper.seek(to: seekTime)
        XCTAssertEqual(playerWrapper.currentTime, seekTime)
    }


    func testRate() {
        let expectedRate: Float = 1.5
        playerWrapper.rate = expectedRate
        XCTAssertEqual(playerWrapper.rate, expectedRate)
    }

    func testSkipForward() {
        let skipInterval = 5.0 // 秒
        let initialTime = playerWrapper.currentTime
        playerWrapper.skipForward(by: skipInterval)
        let expectedTime = CMTimeAdd(initialTime, CMTimeMakeWithSeconds(skipInterval, preferredTimescale: initialTime.timescale))
        XCTAssertEqual(playerWrapper.currentTime, expectedTime)
    }

    func testSkipBackward() {
        // 先に進める
        playerWrapper.skipForward(by: 10.0)

        let skipInterval = 5.0 // 秒
        let initialTime = playerWrapper.currentTime
        playerWrapper.skipBackward(by: skipInterval)
        let expectedTime = CMTimeSubtract(initialTime, CMTimeMakeWithSeconds(skipInterval, preferredTimescale: initialTime.timescale))
        XCTAssertEqual(playerWrapper.currentTime, expectedTime)
    }

}
