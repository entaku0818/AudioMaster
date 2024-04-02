import SwiftUI
import AVFoundation


struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraViewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        cameraViewModel.setupCamera()

        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraViewModel.captureSession!)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
