// AppContext.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation

/// The constants the sample starts from, in one place.
///
/// Modelled on the JavaFX demo's `AppContext`: the Init screen pre-fills its
/// identity fields from here, so pointing the sample somewhere else is one edit
/// in one file rather than a hunt through the views.
enum AppContext {

    /// Deliberately the two values the SDK itself recognises as placeholders and
    /// refuses to initialize with, so a sample nobody has configured says so
    /// loudly instead of quietly sending nothing to a stranger's dashboard.
    static let defaultHost = "https://YOUR_COUNTLY_SERVER"
    static let defaultAppKey = "YOUR_APP_KEY"

    static let defaultDeviceID = "MACOS_SWIFT_DEMO_DEVICE"
    static let appVersion = "1.0.0"

    /// Left empty so the Init screen configures the default instance. Naming it
    /// gives that instance its own storage, device ID and request queue.
    static let defaultInstanceName = ""

    /// A notification that launched the application, captured by the app delegate
    /// before the SDK exists and handed to the config at initialization.
    static var launchNotification: [AnyHashable: Any]?

    /// The name the Init screen last initialized under.
    ///
    /// Written when the SDK is actually started rather than as the field is typed,
    /// so a half-typed instance name never redirects the feature screens at an
    /// instance that was never configured.
    static var activeInstanceName = defaultInstanceName

    /// The instance every feature screen drives.
    ///
    /// Resolved on every access rather than cached: the Init screen can be given a
    /// different name and initialized again without the feature screens still
    /// holding the previous instance. Deliberately not main-actor isolated, so the
    /// Multi Threading screen can reach it from its own queues.
    static var active: CountlyInstance {
        Countly.instance(named: activeInstanceName)
    }
}
