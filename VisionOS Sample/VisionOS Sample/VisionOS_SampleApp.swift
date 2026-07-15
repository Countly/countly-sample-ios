//
//  VisionOS_SampleApp.swift
//  VisionOS Sample
//
//  Created by Deniz Erten on 7/15/26.
//

import SwiftUI
import Countly

@main
struct VisionOS_SampleApp: App {

    @State private var appModel = AppModel()

    init() {
        // Mirrors the iOS sample's test server (see ios/CountlyTestApp-iOS/AppDelegate.m).
        // Point this at a Countly app that has NPS / Survey / Rating widgets and/or a
        // content zone configured and targeted to this device — widgets/content are
        // server-driven, so nothing will render otherwise.
        let config = CountlyConfig()
        config.appKey = "YOUR_APP_KEY"
        config.host = "https://your.server.ly"
        config.enableDebug = true                // prints [Countly] logs to the Xcode console
        config.alwaysUsePOST = true
        if config.appKey == "YOUR_APP_KEY" || config.host == "https://your.server.ly" {
            NSLog("Please do not use the default app key and server url")
        }
        // requiresConsent defaults to false, so feedback & content consent is implicitly granted.
        Countly.sharedInstance().start(with: config)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
