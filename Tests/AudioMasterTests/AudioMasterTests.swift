import XCTest
@testable import AudioMaster

final class AudioMasterTests: XCTestCase {

    var audioMaster:AudioMaster!


    override func setUp() {
        super.setUp()
        guard let url = Bundle.module.url(forResource: "test", withExtension: "m4a") else {
            print("音源ファイルが見つかりません")
            return
        }

        audioMaster = AudioMaster(url: url)
    }

    func testStart() throws {

        audioMaster.play()
        XCTAssertTrue(audioMaster.isPlayng())
    }

    func testSetVolume() throws {
        let volume: Float = 2.5
        audioMaster.setVolume(volume: volume)
        XCTAssertTrue(audioMaster.volume() == volume)
    }

    func testStop() throws {
        audioMaster.stop()
        XCTAssertTrue(!audioMaster.isPlayng())
    }

    // 10秒間録音し、その結果を再生する
    func testRecordStart() throws {
        audioMaster.recordStart()
        let expectation = XCTestExpectation(description: "Your expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.audioMaster.recordStop()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
        guard let url = audioMaster.lastRecordAudioFile() else { return }

        audioMaster = AudioMaster(url: url)
        audioMaster.play()
        XCTAssertTrue(audioMaster.isPlayng())
    }

}
