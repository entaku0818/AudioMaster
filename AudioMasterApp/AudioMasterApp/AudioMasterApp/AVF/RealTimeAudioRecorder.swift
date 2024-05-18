//
//  RealTimeAudioRecorder.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/05/18.
//

import AVFoundation

class RealtimeAudioRecorder: NSObject {
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioFormat: AVAudioFormat!
    private var urlSession: URLSession!
    private var serverURL: URL!

    override init() {
        super.init()

        // URLSessionのセットアップ
        urlSession = URLSession(configuration: .default)
        serverURL = URL(string: "https://yourserver.com/path")!

        // 音声キャプチャのセットアップ
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        audioFormat = inputNode.inputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: audioFormat) { (buffer, when) in
            self.processAudioBuffer(buffer: buffer)
        }

        try? audioEngine.start()
    }

    private func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        let audioData = bufferToData(buffer: buffer)
        sendAudioDataToServer(audioData)
    }

    private func bufferToData(buffer: AVAudioPCMBuffer) -> Data {
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
        let data = Data(bytes: audioBuffer.mData!, count: Int(audioBuffer.mDataByteSize))
        return data
    }

    private func sendAudioDataToServer(_ data: Data) {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        let task = urlSession.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                print("Error uploading audio data: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }

            print("Audio data uploaded successfully")
        }
        task.resume()
    }
}
