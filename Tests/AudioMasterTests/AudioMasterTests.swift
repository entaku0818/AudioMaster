import XCTest
@testable import AudioMaster

final class AudioMasterTests: XCTestCase {

    var audioMaster = AudioMaster()


    func testExample() throws {

        audioMaster.play()
        XCTAssertTrue(audioMaster.isPlayng())
    }

    func testSetVolume() throws {
        let volume: Float = 2.5
        audioMaster.setVolume(volume: volume)
        XCTAssertTrue(audioMaster.volume() == volume)
    }

}
