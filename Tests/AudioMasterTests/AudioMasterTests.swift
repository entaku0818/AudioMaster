import XCTest
@testable import AudioMaster

final class AudioMasterTests: XCTestCase {

    let audioMaster = AudioMaster()


    func testExample() throws {

        audioMaster.play()
        XCTAssertTrue(audioMaster.isPlayng())
    }
}
