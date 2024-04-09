//
//  AVPlayerWrapper.swift
//
//
//  Created by 遠藤拓弥 on 2024/01/18.
//

import Foundation
import AVFoundation


public class AVPlayerWrapper {
    private var player: AVPlayer = AVPlayer()
    private var playerItems: [AVPlayerItem] = []
    private var timeObserverToken: Any?
    private var itemDidPlayToEndObserver: NSObjectProtocol?

    public var avPlayer: AVPlayer {
      return player
    }

    public var volume: Float {
      get { player.volume }
      set { player.volume = newValue }
    }

    public var isPlaying: Bool {
      return player.rate != 0
    }

    public var isPaused: Bool {
      return player.rate == 0 && player.currentTime() != CMTime.zero
    }

    public var currentTime: CMTime {
      return player.currentTime()
    }

    public var rate: Float {
      get { player.rate }
      set { player.rate = newValue }
    }

    public init(urls: [URL]) {
      self.playerItems = urls.map { AVPlayerItem(url: $0) }
      setupEndPlaybackObserver()
      loadNextItem()
    }

    deinit {
      cleanUp()
    }

    private func setupEndPlaybackObserver() {
      itemDidPlayToEndObserver = NotificationCenter.default.addObserver(
          forName: .AVPlayerItemDidPlayToEndTime,
          object: nil,
          queue: .main) { [weak self] _ in
              self?.loadNextItem()
          }
    }

    private func cleanUp() {
      if let observer = timeObserverToken {
          player.removeTimeObserver(observer)
          timeObserverToken = nil
      }
      if let observer = itemDidPlayToEndObserver {
          NotificationCenter.default.removeObserver(observer)
          itemDidPlayToEndObserver = nil
      }
    }

    private func loadNextItem() {
      if !playerItems.isEmpty {
          let nextItem = playerItems.removeFirst()
          player.replaceCurrentItem(with: nextItem)
          player.play()
      } else {
          stop()
      }
    }

    public func play() {
      if player.currentItem == nil && !playerItems.isEmpty {
          loadNextItem()
      } else {
          player.play()
      }
    }

    public func pause() {
      player.pause()
    }

    public func stop() {
      player.pause()
      player.seek(to: CMTime.zero)
      player.replaceCurrentItem(with: nil)
      playerItems.removeAll()
    }

    public func seek(to time: CMTime) {
      player.seek(to: time)
    }

    public func addPeriodicTimeObserver(interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) {
      timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: block)
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

}
