import XCTest
@testable import AudioMaster

final class AudioMasterTests: XCTestCase {

    var audioMaster:AudioMaster!


    override func setUp() {
        super.setUp()
        print(Bundle.module.url(forResource: "test", withExtension: "m4a"))
        guard let url = Bundle.module.url(forResource: "test", withExtension: "m4a") else {
            print("音源ファイルが見つかりません")
            return
        }

        audioMaster = AudioMaster(url: url)
    }

    func testExample() throws {

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

}
