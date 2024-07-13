//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 2024/07/13.
//
import Foundation
import AVFoundation
import Starscream

public class RealTimeAudioUploader: NSObject {
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioFormat: AVAudioFormat!
    private var webSocket: WebSocketProtocol!
    private var isConnected: Bool = false

    public init(webSocket: WebSocketProtocol? = nil) {
        super.init()
        self.webSocket = webSocket ?? WebSocket(request: URLRequest(url: URL(string: "wss://yourserver.com/path")!))
        self.webSocket.delegate = self
        setupAudioEngine()
        if webSocket == nil {
            setupWebSocket()
        }
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        audioFormat = inputNode.inputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: audioFormat) { (buffer, when) in
            self.processAudioBuffer(buffer: buffer)
        }

        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    public func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        let frameLength = Int(buffer.frameLength)
        if let channelData = buffer.floatChannelData?[0] {
            let data = Data(bytes: channelData, count: frameLength * MemoryLayout<Float>.size)
            sendAudioData(data: data)
        }
    }

    private func setupWebSocket() {
        var request = URLRequest(url: URL(string: "wss://yourserver.com/path")!)
        request.timeoutInterval = 5
        webSocket = WebSocket(request: request) as WebSocketProtocol
        webSocket.delegate = self
        webSocket.connect()
    }

    private func sendAudioData(data: Data) {
        if isConnected {
            webSocket.write(data: data, completion: nil)
        } else {
            print("WebSocket is not connected")
        }
    }

    public func stopAudioEngine() {
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
    }
}

extension RealTimeAudioUploader: WebSocketDelegate {
    public func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("WebSocket connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("WebSocket disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .error(let error):
            isConnected = false
            if let error = error {
                print("WebSocket error: \(error)")
            }
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(let isViable):
            print("WebSocket viability changed: \(isViable)")
        case .reconnectSuggested(let shouldReconnect):
            print("WebSocket reconnect suggested: \(shouldReconnect)")
        case .cancelled:
            isConnected = false
            print("WebSocket cancelled")
        case .peerClosed:
            isConnected = false
            print("WebSocket peer closed")
        }
    }
    
}
