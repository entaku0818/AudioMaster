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
        audioPlayer = AudioPlayerMaster()
    }

    override func tearDown() {
        audioPlayer = nil
        super.tearDown()
    }

    func testPlayAudioFromFile() {

        audioPlayer.playAudioFromFile(named: "audio")

        sleep(5)

        XCTAssertTrue(audioPlayer.isPlaying, "Audio should be playing.")
    }

    func testPauseAudio() {
        audioPlayer.playAudioFromFile(named: "audio")

        sleep(1)

        audioPlayer.pauseAudio()

        XCTAssertFalse(audioPlayer.isPlaying, "Audio should be stopped.")
    }

    func testStopAudio() {
        audioPlayer.playAudioFromFile(named: "audio")

        sleep(1)

        audioPlayer.stopAudio()

        XCTAssertFalse(audioPlayer.isPlaying, "Audio should be stopped.")
    }
}
