//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 2024/07/13.
//

import Foundation
import Starscream

public protocol WebSocketProtocol {
    var delegate: WebSocketDelegate? { get set }
    func connect()
    func write(data: Data, completion: (() -> Void)?)
    func disconnect()
}

extension WebSocket: WebSocketProtocol {}
