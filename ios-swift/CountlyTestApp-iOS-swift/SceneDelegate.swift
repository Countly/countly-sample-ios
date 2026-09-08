// SceneDelegate.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit
import SwiftUI

/// The application is scene based, matching the Objective-C sample.
///
/// This is not cosmetic: whether an application adopts scenes decides what
/// `UIApplication.applicationState` reports during `didFinishLaunching`, which is
/// what the SDK checks before opening a session. Two sample applications on
/// different lifecycles report sessions differently for a reason that has nothing
/// to do with the SDK.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let root = UIHostingController(rootView: RootView())
        // Named so the automatic view tracking scenarios can exclude the host's
        // own root screen.
        root.title = "CountlySampleRoot"
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
    }
}
