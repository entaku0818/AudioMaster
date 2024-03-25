//
//  VideoCaptureView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/03/22.
//

import Foundation
import SwiftUI
struct VideoView: View {
    @State private var showingVideoPicker = false
    @State private var videoURL: URL?

    var body: some View {
        VStack {
            Button("Record Video") {
                showingVideoPicker = true
            }
            .fullScreenCover(isPresented: $showingVideoPicker) {
                VideoCaptureView(isShown: $showingVideoPicker, videoURL: $videoURL)
                    .background(.black)
            }

            if let videoURL = videoURL {
                Text("Video URL: \(videoURL)")
            }
        }
    }
}
