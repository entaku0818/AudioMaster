//
//  MockWebSocket.swift
//  
//
//  Created by 遠藤拓弥 on 2024/07/13.
//

import Foundation
import Starscream
@testable import AudioMaster

class MockWebSocket: WebSocketProtocol {
    var delegate: WebSocketDelegate?
    var didSendData: ((Data) -> Void)?
    private(set) var isConnected: Bool = false

    func connect() {
        isConnected = true
        delegate?.didReceive(event: .connected(["": ""]), client: WebSocket(request: URLRequest(url: URL(string: "wss://yourserver.com/path")!)))
    }

    func write(data: Data, completion: (() -> Void)? = nil) {
        didSendData?(data)
        completion?()
    }

    func disconnect() {
        isConnected = false
        delegate?.didReceive(event: .disconnected("Disconnected", 1000), client: WebSocket(request: URLRequest(url: URL(string: "wss://yourserver.com/path")!)))
    }
}
