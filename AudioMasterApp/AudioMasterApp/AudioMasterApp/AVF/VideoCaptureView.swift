//
//  VideoRecordingViewController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/03/22.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI
import UIKit
import AVFoundation

struct VideoCaptureView: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var videoURL: URL?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]
        picker.cameraCaptureMode = .video
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoCaptureView

        init(_ videoCaptureView: VideoCaptureView) {
            self.parent = videoCaptureView
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.videoURL = url
            }
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }
}
