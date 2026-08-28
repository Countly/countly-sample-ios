// UIKitSupport.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import UIKit

enum UIKitSupport {
    /// The top-most presented view controller of the foreground-active scene.
    static func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        var vc = scene?.keyWindow?.rootViewController
        while let presented = vc?.presentedViewController { vc = presented }
        return vc
    }

    static func present(_ viewController: UIViewController) {
        topViewController()?.present(viewController, animated: true)
    }
}

/// Minimal delegate so the legacy NSURLConnection APM demos have a delegate object.
final class APMConnectionDelegate: NSObject, NSURLConnectionDelegate {
    static let shared = APMConnectionDelegate()
}
