//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 10.9.2023.
//

import AVFoundation

public class AudioPlayerMaster {

    private var delegate: Delegate?


    private var audioPlayer: AVAudioPlayer

    public var volume: Float  {
        return audioPlayer.volume
    }

    public var isPlaying: Bool  {
        return audioPlayer.isPlaying
    }

    public var rate: Float  {
        return audioPlayer.rate
    }

    public var enableRate: Bool  {
        return audioPlayer.enableRate
    }

    public init(fileName: String) {
        let audioSession = AVAudioSession.sharedInstance()

        guard let audioFileURL = Bundle.module.url(forResource: fileName, withExtension: "mp3") else {
            fatalError("Audio file not found.")
        }

        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer.prepareToPlay()
        } catch {
            fatalError("Error initializing audio player: \(error.localizedDescription)")
        }


        audioPlayer.enableRate = true
        audioPlayer.isMeteringEnabled = true
    }

    public func playAudioFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }

        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] location, response, error in
            guard let self = self, let location = location, error == nil else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let data = try Data(contentsOf: location)
                self.audioPlayer = try AVAudioPlayer(data: data)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
        

        downloadTask.resume()
    }

    public func playAudio(atTime time: TimeInterval) -> Bool {
        audioPlayer.play(atTime: time)
        return audioPlayer.isPlaying
    }

    public func playAudioAsync(atTime time: TimeInterval) async throws -> Bool {

        let stream = AsyncThrowingStream<Bool, Error> { continuation in
          do {
              self.delegate = try Delegate(didFinishPlaying: { flag in
                  continuation.yield(flag)
                  continuation.finish()
                  try? AVAudioSession.sharedInstance().setActive(false)
              }, decodeErrorDidOccur: { error in
                  continuation.finish(throwing: error)
                  try? AVAudioSession.sharedInstance().setActive(false)
              })


              try AVAudioSession.sharedInstance().setActive(true)
              try AVAudioSession.sharedInstance().setCategory(.playback)
              audioPlayer.delegate = delegate

              audioPlayer.play(atTime: time)
          } catch {
            continuation.finish(throwing: error)
          }
        }

        for try await didFinish in stream {
          return didFinish
        }
        throw CancellationError()
    }

    public func pauseAudio() {
        audioPlayer.pause()
    }

    public func stopAudio() {
        audioPlayer.stop()
    }

    public func setVolume(_ volume: Float, fadeDuration duration: TimeInterval) {
        audioPlayer.setVolume(volume, fadeDuration: duration)
    }

    public func setRate(_ rate: Float) {
        audioPlayer.rate = rate
    }

    public func peakPower() -> Float {
        audioPlayer.updateMeters()
        return audioPlayer.peakPower(forChannel: 0)
    }

    public func averagePower() -> Float {
        audioPlayer.updateMeters()
        return audioPlayer.averagePower(forChannel: 0)
    }
}


private final class Delegate: NSObject, AVAudioPlayerDelegate, Sendable {
  let didFinishPlaying: @Sendable (Bool) -> Void
  let decodeErrorDidOccur: @Sendable (Error?) -> Void

  init(
    didFinishPlaying: @escaping @Sendable (Bool) -> Void,
    decodeErrorDidOccur: @escaping @Sendable (Error?) -> Void
  ) throws {
    self.didFinishPlaying = didFinishPlaying
    self.decodeErrorDidOccur = decodeErrorDidOccur
    super.init()
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.didFinishPlaying(flag)
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    self.decodeErrorDidOccur(error)
  }
}
