//
//  VideoRecordingViewController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/03/22.
//

import Foundation
import UIKit
import AVFoundation

class VideoRecordingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func startVideoRecording() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.cameraCaptureMode = .video
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available")
        }
    }

    // 動画撮影が完了した時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // ここで撮影した動画を取得・保存する処理を行う
        dismiss(animated: true, completion: nil)
    }

    // キャンセル時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
