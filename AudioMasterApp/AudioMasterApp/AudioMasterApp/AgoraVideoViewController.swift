//
//  AgoraVideoViewController.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/02/21.
//


import Foundation
import AgoraRtcKit
import UIKit
import SwiftUI

class AgoraVideoViewController: UIViewController, AgoraRtcEngineDelegate {
    var agoraKit: AgoraRtcEngineKit!
    let appId = "69c50cf0af9a48fbbc2ac98541370280"
    var localUserId: UInt = 0
    var allUsers: Set<UInt> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAgoraEngine()
        setupLocalVideoView()
    }

    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        agoraKit.setChannelProfile(.communication)
        agoraKit.enableVideo()

        agoraKit.joinChannel(byToken: "007eJxTYGAtOpxf9F9kRsPm+QujH2VuW98hzHTB67fs01Lxm+f1PzMpMJhZJpsaJKcZJKZZJppYpCUlJRslJltamJoYGpsbGFkYLPK/mtoQyMhQ0LWbkZEBAkF8FoaS1OISBgYAma0gnQ==", channelId: "test", info: nil, uid: 0) { [weak self] (channel, uid, elapsed) in
            guard let self = self else { return }
            self.localUserId = uid
            self.allUsers.insert(uid)
            print("Joined channel: \(channel) with uid: \(uid)")
        }
    }

    func setupLocalVideoView() {
        let localVideoView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.addSubview(localVideoView)
        setupLocalVideo(on: localVideoView)
    }

    func setupRemoteVideoView(with uid: UInt) {
        let remoteVideoView = UIView(frame: CGRect(x: 0, y: 250, width: 200, height: 200))
        view.addSubview(remoteVideoView)
        setupRemoteVideo(uid: uid, on: remoteVideoView)
    }


    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        allUsers.removeAll()
    }

    func setupLocalVideo(on view: UIView) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = localUserId
        videoCanvas.renderMode = .fit
        videoCanvas.view = view
        agoraKit.setupLocalVideo(videoCanvas)
        agoraKit.startPreview()
    }

    func setupRemoteVideo(uid: UInt, on view: UIView) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .fit
        videoCanvas.view = view
        agoraKit.setupRemoteVideo(videoCanvas)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        allUsers.insert(uid)
        setupRemoteVideoView(with: uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        allUsers.remove(uid)
        // Remove remote video view
        view.subviews.forEach { subview in
            if subview.tag == Int(uid) {
                subview.removeFromSuperview()
            }
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("Agora Error: \(errorCode.rawValue)")
    }
}


struct AgoraVideoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AgoraVideoViewController {
        return AgoraVideoViewController()
    }

    func updateUIViewController(_ uiViewController: AgoraVideoViewController, context: Context) {
    }
}
