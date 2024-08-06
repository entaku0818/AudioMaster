//
//  File.swift
//  
//
//  Created by 遠藤拓弥 on 2024/08/04.
//

import AudioToolbox
import OpenAL


class OpenALUtil {
    var buffer: ALuint = 0
    var source: ALuint = 0

    init(fileName name: String) {
        let device = alcOpenDevice(nil)
        let context = alcCreateContext(device, nil)
        alcMakeContextCurrent(context)

        alGenBuffers(1, &buffer)
        let error: ALenum = alGetError()
        if error != AL_NO_ERROR {
            Swift.print(error.description)
            return
        }

        //open audio-file
        var fileId: AudioFileID? = nil
        let url: CFURL = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "caf")!) as CFURL
        let _: OSStatus = AudioFileOpenURL(url, .readPermission, kAudioFileCAFType, &fileId)

        //get byte-size of audio-file
        var byteCount: UInt64 = 0
        var propertySize = UInt32(MemoryLayout.size(ofValue: byteCount))
        let _: OSStatus = AudioFileGetProperty(fileId!, kAudioFilePropertyAudioDataByteCount, &propertySize, &byteCount)

        //read audio-file
        var bytesRead = UInt32(byteCount)
        let audioData = malloc(Int(bytesRead))!
        let _: OSStatus = AudioFileReadBytes(fileId!, false, 0, &bytesRead, audioData)

        //close audio-file
        let _: OSStatus = AudioFileClose(fileId!)

        //data into buffer
        alGenBuffers(1, &buffer)
        alBufferData(buffer, AL_FORMAT_MONO16, audioData, ALsizei(bytesRead), 44100)

        //write buffer to source
        alGenSources(1, &source)
        alSourcei(source, AL_LOOPING, AL_TRUE)
        alSourcei(source, AL_BUFFER, ALint(buffer))
    }

    public func play() {
        alSourcePlay(source)
    }

    public func pause() {
        alSourcePause(source)
    }

    public func stop() {
        alSourceStop(source)
    }
}
