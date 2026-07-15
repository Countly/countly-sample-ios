// Feature.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    let destination: AnyView
}

@MainActor
let features: [Feature] = [
    Feature(title: "Custom Events", systemImage: "bolt", destination: AnyView(CustomEventsView())),
    Feature(title: "Sessions", systemImage: "clock", destination: AnyView(SessionsView())),
    Feature(title: "Views", systemImage: "rectangle.stack", destination: AnyView(ViewsView())),
    Feature(title: "User Profile", systemImage: "person.crop.circle", destination: AnyView(UserProfileView())),
    Feature(title: "Crash Reporting", systemImage: "ant", destination: AnyView(CrashReportingView())),
    Feature(title: "Remote Config", systemImage: "slider.horizontal.3", destination: AnyView(RemoteConfigView())),
    Feature(title: "Feedback", systemImage: "star.bubble", destination: AnyView(FeedbackView())),
    Feature(title: "Content", systemImage: "square.on.square", destination: AnyView(ContentZoneView())),
    Feature(title: "Push Notifications", systemImage: "bell", destination: AnyView(PushNotificationsView())),
    Feature(title: "Consent", systemImage: "checkmark.shield", destination: AnyView(ConsentView())),
    Feature(title: "Device ID", systemImage: "number", destination: AnyView(DeviceIDView())),
    Feature(title: "Attribution", systemImage: "arrow.triangle.branch", destination: AnyView(AttributionView())),
    Feature(title: "APM / Networking", systemImage: "network", destination: AnyView(APMView())),
    Feature(title: "Multi Threading", systemImage: "cpu", destination: AnyView(MultiThreadingView())),
    Feature(title: "Requests & Utilities", systemImage: "wrench.and.screwdriver", destination: AnyView(RequestsUtilitiesView())),
]
