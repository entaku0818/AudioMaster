//
//  AudioMasterAppApp.swift
//  AudioMasterApp
//
//  Created by 遠藤拓弥 on 2024/01/18.
//

import SwiftUI

@main
struct AudioMasterApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    print("Received background notification in SwiftUI view")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    print("Received foreground notification in SwiftUI view")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("Received active notification in SwiftUI view")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    print("Received terminate notification in SwiftUI view")
                }
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // アプリが起動したときの処理
        print("App has launched")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // アプリが非アクティブになる前の処理
        print("App will resign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // アプリがバックグラウンドに入ったときの処理
        print("App entered background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // アプリがフォアグラウンドに戻る前の処理
        print("App will enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // アプリがアクティブになったときの処理
        print("App became active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // アプリが終了するときの処理
        print("App will terminate")
    }
}
