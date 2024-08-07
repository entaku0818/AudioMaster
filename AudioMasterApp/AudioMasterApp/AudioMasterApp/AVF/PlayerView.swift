//
//  PlayerView.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/02/29.
//

import SwiftUI
import AVKit
import AudioMaster
import Foundation

struct PlayerView: View {
    private let player:AVPlayerWrapper

    init() {
        player = AVPlayerWrapper(urls:
                [
                    URL.init(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!,
                    Bundle.main.url(forResource: "sample", withExtension: "mp4")!,
                    Bundle.main.url(forResource: "sample2", withExtension: "mp4")!,
                ]
        )
    }

    var body: some View {
        HStack{
            VideoPlayer(player: player.avPlayer)
            .onAppear() {
                self.player.play()
            }.onDisappear() {
                self.player.pause()
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
