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

    

    func testPauseAudio() {
        audioPlayer.playAudio(atTime: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.audioPlayer.pauseAudio()
            XCTAssertFalse(self.audioPlayer.isPlaying, "Audio should be paused.")
        }
    }

    func testStopAudio() {
        audioPlayer.playAudio(atTime: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.audioPlayer.stopAudio()
            XCTAssertFalse(self.audioPlayer.isPlaying, "Audio should be stopped.")
        }
    }

    func testSetVolume() {
         let expectedVolume: Float = 0.5
         let fadeDuration: TimeInterval = 1  // 1秒で音量を変更

         audioPlayer.setVolume(expectedVolume, fadeDuration: fadeDuration)

         // 音量が変更される時間を待機
         let expectation = XCTestExpectation(description: "Wait for volume to change")
         DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration + 0.1) {
             expectation.fulfill()
         }
         wait(for: [expectation], timeout: fadeDuration + 0.5)

         // 最終的な音量が期待値と一致するか確認
         XCTAssertEqual(audioPlayer.volume, expectedVolume, accuracy: 0.1, "Volume should be set to the expected value")
     }

    func testSetRate() {
        // Set a test rate value
        let testRate: Float = 1.5
        audioPlayer.setRate(testRate)

        // Assert that the rate of the audio player is set correctly
        XCTAssertTrue(audioPlayer.enableRate, "Audio should be stopped.")
        XCTAssertEqual(audioPlayer.rate, testRate, "Rate was not set correctly")
    }

    func testPlayAudioFromURL() {
        self.audioPlayer.stopAudio()

        let firebaseStorageURL = "https://firebasestorage.googleapis.com/v0/b/voilog.appspot.com/o/maou_game_battle01.mp3?alt=media&token=46686424-e2e2-4230-a65e-93aeb199fd39"
        audioPlayer.playAudioFromURL(firebaseStorageURL)

        // ダウンロードと再生が完了するのを待つ

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // ここでaudioPlayerMasterの状態を検証
            XCTAssertTrue(self.audioPlayer.isPlaying)
        }

    }
}
