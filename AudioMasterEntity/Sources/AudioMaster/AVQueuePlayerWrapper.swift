//
//  AVQueuePlayerWrapper.swift
//
//
//  Created by 遠藤拓弥 on 2024/01/24.
//

import Foundation
import AVFoundation

public class AVQueuePlayerWrapper {
    private var queuePlayer: AVQueuePlayer

    public init(items: [AVPlayerItem]) {
        self.queuePlayer = AVQueuePlayer(items: items)
    }

    public func play() {
        queuePlayer.play()
    }

    public func pause() {
        queuePlayer.pause()
    }

    public func advanceToNextItem() {
        queuePlayer.advanceToNextItem()
    }

    public func canInsert(item: AVPlayerItem, after afterItem: AVPlayerItem?) -> Bool {
        return queuePlayer.canInsert(item, after: afterItem)
    }

    public func insert(item: AVPlayerItem, after afterItem: AVPlayerItem?) {
        queuePlayer.insert(item, after: afterItem)
    }

    public func remove(item: AVPlayerItem) {
        queuePlayer.remove(item)
    }

    public func removeAllItems() {
        queuePlayer.removeAllItems()
    }

    public func items() -> [AVPlayerItem] {
        return queuePlayer.items()
    }

}
