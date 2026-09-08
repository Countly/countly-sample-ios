//  AppDelegate.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit
import SwiftUI

// The SDK sources are compiled into this target from the `countly-sdk-swift`
// submodule, so there is nothing to import.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // The SDK is started from the Setup screen (see SDKSession), or here when the tester
        // asked for automatic initialization with previously entered values.
        let setup = SetupStore().load()
        if setup.autoInit, setup.validationError == nil {
            SDKSession.shared.initialize(with: setup)
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: RootView())
        window.makeKeyAndVisible()
        self.window = window

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Countly.didFailToRegisterForRemoteNotifications(error: error)
    }
}
