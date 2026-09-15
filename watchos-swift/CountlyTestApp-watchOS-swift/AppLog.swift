// AppLog.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import Foundation
import Combine

/// What the sample itself did, shown at the bottom of the screen and printed with
/// the SDK's own lines so a console capture reads in order.
final class AppLog: ObservableObject {

    static let shared = AppLog()

    @Published private(set) var lines: [String] = []

    func log(_ message: String) {
        NSLog("[Sample] %@", message)
        DispatchQueue.main.async {
            self.lines.append(message)
            if self.lines.count > 30 {
                self.lines.removeFirst(self.lines.count - 30)
            }
        }
    }
}
