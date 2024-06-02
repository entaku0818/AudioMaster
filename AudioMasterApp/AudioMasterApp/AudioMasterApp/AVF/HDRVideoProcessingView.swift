
import SwiftUI
import AVKit
import Photos
import PhotosUI
import SwiftUI
import AVKit
import Photos
import PhotosUI

struct HDRVideoProcessingView: View {
    @State private var videoURL: URL?
    @State private var player: AVPlayer?
    @State private var isPickerPresented = false

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 300)
                    .onAppear {
                        player.play()
                    }
            } else {
                Text("No video selected")
                    .frame(height: 300)
            }

            HStack {
                Button(action: { isPickerPresented.toggle() }) {
                    Text("Load Video")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $isPickerPresented) {
                    VideoPicker(videoURL: $videoURL, player: $player)
                }

                Button(action: exportSDRVideo) {
                    Text("Export SDR Video")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(videoURL == nil)
            }
        }
    }

    private func exportSDRVideo() {
        guard let videoURL = videoURL else { return }

        let asset = AVAsset(url: videoURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            print("Failed to create export session")
            return
        }

        // ユニークなファイル名を使用して一時ファイルを生成
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        exportSession.shouldOptimizeForNetworkUse = true

        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("Export completed successfully")
                self.saveVideoToPhotoLibrary(outputURL)
            case .failed:
                if let error = exportSession.error {
                    print("Export failed: \(error.localizedDescription)")
                }
            case .cancelled:
                print("Export cancelled")
            default:
                break
            }
        }
    }

    private func saveVideoToPhotoLibrary(_ url: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { success, error in
            if success {
                print("Video saved to Photo Library")
            } else if let error = error {
                print("Error saving video to Photo Library: \(error.localizedDescription)")
            }
        }
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Binding var player: AVPlayer?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)

            guard let result = results.first else { return }

            result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                if let error = error {
                    print("Error loading video: \(error.localizedDescription)")
                    return
                }

                guard let url = url else {
                    print("No URL found")
                    return
                }

                // Ensure the URL is a local file
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")

                do {
                    // Remove existing file if it exists
                    if FileManager.default.fileExists(atPath: tempURL.path) {
                        try FileManager.default.removeItem(at: tempURL)
                    }
                    try FileManager.default.copyItem(at: url, to: tempURL)
                    DispatchQueue.main.async {
                        self.parent.videoURL = tempURL
                        self.parent.player = AVPlayer(url: tempURL)
                    }
                } catch {
                    print("Error copying file: \(error.localizedDescription)")
                }
            }
        }
    }
}
