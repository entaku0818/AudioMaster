//
//  AudioSessionController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/12/07.
//

import Foundation
import AVFoundation
import os.log

class AudioSessionController: NSObject, ObservableObject {
    static let shared = AudioSessionController()

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.audiomaster",
        category: "AudioSession"
    )

    @Published var isRecording = false
    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?

    // 追加：音声合成関連
    private let speechSynthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false

    private let defaultVoice = AVSpeechSynthesisVoice(language: "ja-JP")

    private override init() {
        super.init()
        setupNotifications()
        setupAudioPlayer()
        speechSynthesizer.delegate = self
    }

    // MARK: - Setup Methods
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleInterruption(notification)
        }
    }

    private func setupAudioPlayer() {
        guard let audioURL = Bundle.main.url(forResource: "sfc-harukanaru-daichi_Loop", withExtension: "mp3") else {
            logger.error("Audio file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
        } catch {
            logger.error("Failed to setup audio player: \(error.localizedDescription)")
        }
    }

    // MARK: - Audio Session Configuration Methods
    func configureStandardPlayback() {
        do {
            audioPlayer?.stop()
            try checkBackgroundAudioConfiguration()

            let audioSession = AVAudioSession.sharedInstance()
            // 基本的なplaybackカテゴリの設定
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)

            logger.info("Configured standard background playback")
            audioPlayer?.play()
            logger.info("Started standard playback successfully")
        } catch let error as ConfigurationError {
            logger.error("\(error.localizedDescription)")
        } catch {
            logger.error("Failed to configure standard playback: \(error.localizedDescription)")
        }
    }

    /// 他のアプリの音声を小さくして残す
    func configureRespectOtherApps() {
        do {
            audioPlayer?.stop()

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playback,
                options: [
                    .duckOthers,
                ]
            )
            try audioSession.setActive(true)

            logger.info("Configured playback to respect other apps")
            audioPlayer?.play()
            logger.info("Started playback with lower priority")
        } catch {
            logger.error("Failed to configure respect other apps mode: \(error.localizedDescription)")
        }
    }

    ///
    func configurePrioritizeOurAudio() {
        do {
            audioPlayer?.stop()

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playback,
                mode: .spokenAudio,
                options: [
                    .interruptSpokenAudioAndMixWithOthers
                ]
            )
            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])

            logger.info("Configured playback to prioritize our audio")
            audioPlayer?.play()
            logger.info("Started playback with high priority")
        } catch {
            logger.error("Failed to configure prioritize our audio mode: \(error.localizedDescription)")
        }
    }

    func configureTextToSpeech(text: String) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playback,
                mode: .spokenAudio,
                options: []
            )
            try audioSession.setActive(true)

            stopSpeaking()

            let utterance = AVSpeechUtterance(string: text)

            speechSynthesizer.delegate = self

            logger.info("Configured audio session for text-to-speech")
            speechSynthesizer.speak(utterance)
            isSpeaking = true
            logger.info("Started speaking text: \(text)")

        } catch {
            logger.error("Failed to configure text-to-speech: \(error.localizedDescription)")
        }
    }

    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            isSpeaking = false
            logger.info("Stopped speaking")
        }
    }

    // MARK: - Playback Control Methods
    func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        logger.info("Stopped audio playback")
    }

    private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            audioPlayer?.pause()
            logger.info("Audio interrupted")
        case .ended:
            let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt
            let options = optionsValue.map { AVAudioSession.InterruptionOptions(rawValue: $0) }
            if options?.contains(.shouldResume) == true {
                audioPlayer?.play()
                logger.info("Audio resumed after interruption")
            }
        @unknown default:
            break
        }
    }

    // MARK: - Cleanup
    deinit {
        stopPlayback()
        NotificationCenter.default.removeObserver(self)
    }
    enum ConfigurationError: Error {
         case backgroundModesNotFound
         case audioModeNotEnabled

         var localizedDescription: String {
             switch self {
             case .backgroundModesNotFound:
                 return "UIBackgroundModes not found in Info.plist. Please add background mode configuration."
             case .audioModeNotEnabled:
                 return "Audio mode is not enabled in UIBackgroundModes. Please enable 'App plays audio' background mode."
             }
         }
     }

     func checkBackgroundAudioConfiguration() throws {
         guard let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] else {
             logger.error("UIBackgroundModes not found in Info.plist")
             throw ConfigurationError.backgroundModesNotFound
         }

         let hasAudioMode = backgroundModes.contains("audio")
         logger.info("Background audio mode is \(hasAudioMode ? "enabled" : "disabled")")

         if !hasAudioMode {
             logger.warning("UIBackgroundModes does not contain 'audio'. Background playback may not work.")
             throw ConfigurationError.audioModeNotEnabled
         }
     }
}

extension AudioSessionController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
        logger.info("Speech started")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        logger.info("Speech finished")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
        logger.info("Speech paused")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isSpeaking = true
        logger.info("Speech continued")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        logger.info("Speech cancelled")
    }
}
