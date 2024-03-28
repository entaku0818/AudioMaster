import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var capturedImage: UIImage?

    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(for: .video) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession!.canAddInput(input) {
                captureSession?.addInput(input)
            }
        } catch {
            print(error)
            return
        }

        photoOutput = AVCapturePhotoOutput()
        if captureSession!.canAddOutput(photoOutput!) {
            captureSession?.addOutput(photoOutput!)
        }

        captureSession?.startRunning()
    }

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        capturedImage = UIImage(data: imageData)
    }
}

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

struct CameraPreviewContentView: View {
    @StateObject private var cameraViewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraPreview(cameraViewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Button(action: {
                    cameraViewModel.takePhoto()
                }) {
                    Image(systemName: "circle")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                }

                Spacer().frame(height: 50)
            }
        }
        .sheet(item: $cameraViewModel.capturedImage) { image in
            ImageView(image: image)
        }
    }
}

struct ImageView: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

extension UIImage: Identifiable {
    public var id: UUID {
        UUID()
    }
}
