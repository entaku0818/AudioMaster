//
//  CameraViewModel.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/02.
//

import Foundation
import AVFoundation
import UIKit
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
