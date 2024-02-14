//
//  WavySoundAnimationView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/02/14.
//

import Foundation
import SwiftUI


struct WavySoundAnimationView: View {
    @State private var scale: CGFloat = 0.5 // 初期スケール値
    var audioStrength: CGFloat // 外部から渡される音の強さ (0.0 〜 1.0)

    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scaleEffect(scale)
            .frame(width: 100, height: 100)
            .onAppear {
                // アニメーションを開始
                withAnimation(.easeInOut(duration: 1)) {
                    // 音の強さに応じてスケールを変更
                    scale = 0.5 + (audioStrength / 2) // 音の強さに基づいてスケールを調整
                }
            }
            .onChange(of: audioStrength) { newValue in
                // 音の強さの変化に応じてアニメーションを更新
                withAnimation(.easeInOut(duration: 1)) {
                    scale = 0.5 + (newValue / 2) // 音の強さに基づいてスケールを調整
                }
            }
    }
}

struct WavySoundAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        WavySoundAnimationView(audioStrength: 0.5)
    }
}

