//
//  HDRVideoProcessingView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/06/02.
//

import SwiftUI
import AVFoundation
import PhotosUI
import _AVKit_SwiftUI

struct HDRVideoProcessingView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: HDRVideoCaptureView()) {
                    Text("Capture HDR Video")
                        .font(.system(size: 20))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: HDRVideoPlaybackView()) {
                    Text("Playback HDR Video")
                        .font(.system(size: 20))
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                NavigationLink(destination: HDRVideoEditView()) {
                    Text("Edit HDR Video")
                        .font(.system(size: 20))
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("HDR Video Processing")
        }
    }
}

struct HDRVideoCaptureView: View {
    var body: some View {
        VStack {
            Text("Capture HDR Video")
                .font(.largeTitle)
                .padding()
            // ビデオキャプチャのUIと機能をここに追加
        }
        .navigationTitle("Capture HDR Video")
    }
}

struct HDRVideoPlaybackView: View {
    var body: some View {
        VStack {
            Text("Playback HDR Video")
                .font(.largeTitle)
                .padding()
            // ビデオ再生のUIと機能をここに追加
        }
        .navigationTitle("Playback HDR Video")
    }
}

struct HDRVideoEditView: View {
    @State private var isPickerPresented = false
    @State private var videoURL: URL?

    var body: some View {
        VStack {
            if let videoURL = videoURL {
                Text("Selected video: \(videoURL.lastPathComponent)")
                    .padding()
            } else {
                Text("No video selected")
                    .padding()
            }

            Button(action: {
                isPickerPresented = true
            }) {
                Text("Select Video")
                    .font(.system(size: 20))
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Edit HDR Video")
        .sheet(isPresented: $isPickerPresented) {
            VideoPickerView(videoURL: $videoURL)
        }
    }
}

struct VideoPickerView: UIViewControllerRepresentable {
    @Binding var videoURL: URL?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: VideoPickerView

        init(_ parent: VideoPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error) in
                    DispatchQueue.main.async {
                        self.parent.videoURL = url
                    }
                }
            }
        }
    }
}
