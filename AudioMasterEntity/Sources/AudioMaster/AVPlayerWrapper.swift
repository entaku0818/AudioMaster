//
//  AVPlayerWrapper.swift
//
//
//  Created by 遠藤拓弥 on 2024/01/18.
//

import Foundation
import AVFoundation

import Foundation
import AVFoundation

public class AVPlayerWrapper {
    private var player: AVPlayer
    private var playerItem: AVPlayerItem?
    private var timeObserverToken: Any?
    private var itemDidPlayToEndObserver: NSObjectProtocol?

    public var volume: Float {
        get { player.volume }
        set { player.volume = newValue }
    }

    public var isPlaying: Bool {
        player.rate != 0
    }

    public var isPaused: Bool {
        player.rate == 0 && player.currentTime() != CMTime.zero
    }

    public var currentTime: CMTime {
        player.currentTime()
    }

    public var rate: Float {
        get { player.rate }
        set { player.rate = newValue }
    }

    public init(url: URL) {
        self.playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        setupEndPlaybackObserver()
    }

    deinit {
        if let observer = timeObserverToken {
            player.removeTimeObserver(observer)
        }
        if let observer = itemDidPlayToEndObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setupEndPlaybackObserver() {
        itemDidPlayToEndObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main) { [weak self] _ in
                self?.player.seek(to: CMTime.zero)
                self?.player.pause()
            }
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

    public func skipForward(by seconds: Double) {
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTime.timescale))
        player.seek(to: newTime)
    }

    public func skipBackward(by seconds: Double) {
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(seconds, preferredTimescale: currentTime.timescale))
        player.seek(to: newTime)
    }

    public func addPeriodicTimeObserver(interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) {
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: block)
    }
}
