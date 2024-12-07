//
//  AudioSessionController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/12/07.
//

import Foundation
import AVFoundation
import os.log

import Foundation
import AVFoundation
import os.log

class AudioSessionController: ObservableObject {
    static let shared = AudioSessionController()

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.audiomaster",
        category: "AudioSession"
    )

    @Published var isRecording = false
    private var audioPlayer: AVAudioPlayer?
    private var audioRecorder: AVAudioRecorder?

    private init() {
        setupNotifications()
        setupAudioPlayer()
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
    func configureBackgroundPlayback() {
        do {
            audioPlayer?.stop()
            try checkBackgroundAudioConfiguration()
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)

            logger.info("Configured audio session for background playback")
            audioPlayer?.play()
            logger.info("Started background playback successfully")
        } catch let error as ConfigurationError {
            logger.error("\(error.localizedDescription)")
        } catch {
            logger.error("Failed to configure background playback: \(error.localizedDescription)")
        }
    }

    func configureMixWithOthers() {
        do {
            audioPlayer?.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, options: [.mixWithOthers])
            try audioSession.setActive(true)

            logger.info("Configured audio session with mixWithOthers option")
            audioPlayer?.play()
            logger.info("Started playback with mixWithOthers successfully")
        } catch {
            logger.error("Failed to configure mixWithOthers playback: \(error.localizedDescription)")
        }
    }


    func configureRecording() {
        if !isRecording {
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
                guard let self = self else { return }

                if allowed {
                    self.logger.info("Microphone permission granted")
                    do {
                        try self.startRecording()
                        self.logger.info("Started recording successfully")
                    } catch {
                        self.logger.error("Failed to start recording: \(error.localizedDescription)")
                    }
                } else {
                    self.logger.warning("Microphone permission denied")
                }
            }
        }
    }

    private func startRecording() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord)
        try audioSession.setActive(true)
        logger.debug("Audio session configured for recording")
        isRecording = true
    }

    func configureNotificationSound() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient)
            try audioSession.setActive(true)

            logger.info("Configured audio session for notification sound")
            audioPlayer?.play()
            logger.info("Started notification sound playback")
        } catch {
            logger.error("Failed to play notification sound: \(error.localizedDescription)")
        }
    }

    func configureGameSound() {
        do {
            audioPlayer?.stop()

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, options: [.mixWithOthers])
            try audioSession.setActive(true)

            logger.info("Configured audio session for game sound")
            audioPlayer?.play()
            logger.info("Started game sound playback")
        } catch {
            logger.error("Failed to configure game sound: \(error.localizedDescription)")
        }
    }

    func configureVideoConference() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord,
                                   mode: .voiceChat,
                                   options: [.allowBluetooth, .defaultToSpeaker])
            try audioSession.setActive(true)

            logger.info("Configured audio session for video conference")
            audioPlayer?.play()
            logger.info("Started video conference playback")
        } catch {
            logger.error("Failed to configure video conference: \(error.localizedDescription)")
        }
    }

    func configurePodcast() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback,
                                   options: [.allowAirPlay, .allowBluetoothA2DP])
            try audioSession.setActive(true)

            logger.info("Configured audio session for podcast playback")
            audioPlayer?.play()
            logger.info("Started podcast playback")
        } catch {
            logger.error("Failed to configure podcast playback: \(error.localizedDescription)")
        }
    }

    func configureVoiceMessage() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord,
                                   mode: .voiceChat,
                                   options: [.allowBluetooth, .overrideMutedMicrophoneInterruption])
            try audioSession.setActive(true)

            logger.info("Configured audio session for voice message")
            audioPlayer?.play()
            logger.info("Started voice message playback")
        } catch {
            logger.error("Failed to configure voice message: \(error.localizedDescription)")
        }
    }

    func configureTextToSpeech() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback,
                                   options: [.mixWithOthers, .duckOthers])
            try audioSession.setActive(true)

            logger.info("Configured audio session for text-to-speech")
            audioPlayer?.play()
            logger.info("Started text-to-speech playback")
        } catch {
            logger.error("Failed to configure text-to-speech: \(error.localizedDescription)")
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
