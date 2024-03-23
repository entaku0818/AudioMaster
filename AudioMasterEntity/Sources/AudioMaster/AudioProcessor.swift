//
//  AudioProcessor.swift
//
//
//  Created by 遠藤拓弥 on 2024/03/23.
//

import Foundation
import AVFoundation
import AudioToolbox

public class AudioProcessor {
    var audioQueue: AudioQueueRef?
    var audioFile: AudioFileID?
    var isRecording = false
    var isPlaying = false
    var audioBufferList: AudioBufferList?
    var audioFormat: AudioStreamBasicDescription
    var numPackets: UInt32 = 0

    public init() {
        audioFormat = AudioStreamBasicDescription(mSampleRate: 44100.0,
                                                  mFormatID: kAudioFormatLinearPCM,
                                                  mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
                                                  mBytesPerPacket: 2,
                                                  mFramesPerPacket: 1,
                                                  mBytesPerFrame: 2,
                                                  mChannelsPerFrame: 1,
                                                  mBitsPerChannel: 16,
                                                  mReserved: 0)
    }

    public func startRecording() {
        var recordFormat = audioFormat
        AudioQueueNewInput(&recordFormat, audioQueueInputCallback, Unmanaged.passUnretained(self).toOpaque(), nil, nil, 0, &audioQueue)

        let bufferByteSize: UInt32 = 2048 // Adjust as necessary
        for _ in 0..<3 {
            var buffer: AudioQueueBufferRef?
            AudioQueueAllocateBuffer(audioQueue!, bufferByteSize, &buffer)
            if let buffer = buffer {
                AudioQueueEnqueueBuffer(audioQueue!, buffer, 0, nil)
            }
        }

        isRecording = true
        AudioQueueStart(audioQueue!, nil)
    }

    public func stopRecording() {
        isRecording = false
        AudioQueueStop(audioQueue!, true)
        AudioQueueDispose(audioQueue!, true)
    }

    public func startPlayback() {
        guard !isPlaying else { return }
        isPlaying = true
        AudioQueueNewOutput(&audioFormat, audioQueueOutputCallback, Unmanaged.passUnretained(self).toOpaque(), nil, nil, 0, &audioQueue)

        let bufferByteSize: UInt32 = 2048 // Adjust as necessary
        for _ in 0..<3 {
            var buffer: AudioQueueBufferRef?
            AudioQueueAllocateBuffer(audioQueue!, bufferByteSize, &buffer)
            if let buffer = buffer {
                audioQueueOutputCallback(Unmanaged.passUnretained(self).toOpaque(), audioQueue!, buffer)
            }
        }

        AudioQueueStart(audioQueue!, nil)
    }

    public func stopPlayback() {
        isPlaying = false
        AudioQueueStop(audioQueue!, true)
        AudioQueueDispose(audioQueue!, true)
    }

    let audioQueueInputCallback: AudioQueueInputCallback = { inUserData, inAQ, inBuffer, inStartTime, inNumPackets, inPacketDesc in
        let audioProcessor = Unmanaged<AudioProcessor>.fromOpaque(inUserData!).takeUnretainedValue()
        if audioProcessor.isRecording {
            // Here, you would process the input buffer as needed or write it to a file
            print("Recording buffer received")
        }
        if audioProcessor.isRecording {
            AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
        }
    }

    let audioQueueOutputCallback: AudioQueueOutputCallback = { inUserData, inAQ, inBuffer in
        let audioProcessor = Unmanaged<AudioProcessor>.fromOpaque(inUserData!).takeUnretainedValue()
        if audioProcessor.isPlaying {
            // Here, you would fill the buffer with audio data to play back
            print("Playback buffer requested")
        }
    }
}
