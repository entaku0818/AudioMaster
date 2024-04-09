//
//  PiPVideoPlayerView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/09.
//
import SwiftUI
import AVKit
import AudioMaster

class VideoPlayerViewController: UIViewController, AVPictureInPictureControllerDelegate {
    private var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    private var pipController: AVPictureInPictureController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupPiP()
    }

    private func setupPlayer() {
        guard let player = player else { return }
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.view.bounds
        playerLayer?.videoGravity = .resizeAspect
        if let playerLayer = playerLayer {
            self.view.layer.addSublayer(playerLayer)
        }
    }

    private func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("PiP is not supported on this device.")
            return
        }

        pipController = AVPictureInPictureController(playerLayer: playerLayer!)
        pipController?.delegate = self
    }

    func startPiP() {
        pipController?.startPictureInPicture()
    }

}


// SwiftUI wrapper for VideoPlayerViewController
struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> VideoPlayerViewController {
        let viewController = VideoPlayerViewController()
        viewController.player = player
        return viewController
    }

    func updateUIViewController(_ uiViewController: VideoPlayerViewController, context: Context) {
    }
}

struct PiPVideoPlayerView: View {
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "sample2", withExtension: "mp4")!)
    var body: some View {
        VStack {
            VideoPlayerView(player: player)
                .onAppear { self.player.play() }
                .onDisappear { self.player.pause() }
                .edgesIgnoringSafeArea(.all)
            Button("Start PiP") {
                // Access your VideoPlayerViewController and start PiP
                if let viewController = UIApplication.shared.windows.first?.rootViewController as? VideoPlayerViewController {
                    viewController.startPiP()
                }
            }
        }
    }
}

struct PiPVideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PiPVideoPlayerView()
    }
}
