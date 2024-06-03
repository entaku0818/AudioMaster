import Foundation
import AudioToolbox

class AudioCoreRecorder {
    private var queue: AudioQueueRef?
    private var format: AudioStreamBasicDescription
    private var file: AudioFileID?
    private var currentPacket: Int64 = 0

    init() {
        self.format = AudioStreamBasicDescription(
            mSampleRate: 44100.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )
    }

    private let audioQueueCallback: AudioQueueInputCallback = { (
        inUserData: UnsafeMutableRawPointer?,
        inAQ: AudioQueueRef,
        inBuffer: AudioQueueBufferRef,
        inStartTime: UnsafePointer<AudioTimeStamp>,
        inNumPackets: UInt32,
        inPacketDesc: UnsafePointer<AudioStreamPacketDescription>?
    ) in
        guard let inUserData = inUserData else { return }
        let recorder = inUserData.assumingMemoryBound(to: AudioCoreRecorder.self).pointee

        var numPackets = inNumPackets

        if numPackets > 0 {
            AudioFileWritePackets(
                recorder.file!,
                false,
                inBuffer.pointee.mAudioDataByteSize,
                inPacketDesc,
                recorder.currentPacket,
                &numPackets,
                inBuffer.pointee.mAudioData
            )
            recorder.currentPacket += Int64(numPackets)
        }

        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
    }

    func startRecording() {
        var format = self.format
        AudioQueueNewInput(
            &format,
            audioQueueCallback,
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
            nil,
            nil,
            0,
            &self.queue
        )

        guard let queue = self.queue else { return }

        // ファイルの作成
        let filePath = NSTemporaryDirectory() + "recording.caf"
        let fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, filePath as CFString, .cfurlposixPathStyle, false)
        AudioFileCreateWithURL(
            fileURL!,
            kAudioFileCAFType,
            &format,
            .eraseFile,
            &self.file
        )

        // バッファを準備
        let bufferSize: UInt32 = 1024
        for _ in 0..<3 {
            var buffer: AudioQueueBufferRef?
            AudioQueueAllocateBuffer(queue, bufferSize, &buffer)
            AudioQueueEnqueueBuffer(queue, buffer!, 0, nil)
        }

        AudioQueueStart(queue, nil)
        print("Recording started")
    }

    func stopRecording() {
        guard let queue = self.queue else { return }
        AudioQueueStop(queue, true)
        AudioQueueDispose(queue, true)
        if let file = self.file {
            AudioFileClose(file)
        }
        print("Recording stopped")
    }
}
