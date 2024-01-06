//
//  AudioPlayerMasterTests.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import Foundation
import XCTest
@testable import AudioMaster

class AudioPlayerMasterTests: XCTestCase {
    var audioPlayer: AudioPlayerMaster!

    override func setUp() {
        super.setUp()
        // Assuming "testAudio" is a valid file in your test bundle
        audioPlayer = AudioPlayerMaster(fileName: "audio")
    }

    override func tearDown() {
        audioPlayer = nil
        super.tearDown()
    }

    func testPlayAudio() {
        let expectation = XCTestExpectation(description: "Audio should start playing")

        audioPlayer.playAudio()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.audioPlayer.isPlayngAudio() {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2)
    }

    func testPauseAudio() {
        audioPlayer.playAudio()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.audioPlayer.pauseAudio()
            XCTAssertFalse(self.audioPlayer.isPlayngAudio(), "Audio should be paused.")
        }
    }

    func testStopAudio() {
        audioPlayer.playAudio()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.audioPlayer.stopAudio()
            XCTAssertFalse(self.audioPlayer.isPlayngAudio(), "Audio should be stopped.")
        }
    }
}
