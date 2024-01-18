//
//  AVPlayerWrapper.swift
//
//
//  Created by 遠藤拓弥 on 2024/01/18.
//

import Foundation
import AVFoundation

public class AVPlayerWrapper {
    private var player: AVPlayer
    private var playerItem: AVPlayerItem?

    public var volume: Float {
        get {
            return player.volume
        }
        set {
            player.volume = newValue
        }
    }

    public var isPlaying: Bool {
        return player.rate != 0
    }

    public var currentTime: CMTime {
        return player.currentTime()
    }

    public init(url: URL) {
        self.playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
    }

    public func play() {
        player.play()
    }

    public func pause() {
        player.pause()
    }

    public func stop() {
        player.pause()
        player.seek(to: CMTime.zero)
    }

    public func seek(to time: CMTime) {
        player.seek(to: time)
    }
}
