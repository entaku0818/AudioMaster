//
//  File.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/04/02.
//

import Foundation
import SwiftUI

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
