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
    let tint: Color
    let destination: AnyView
}

struct FeatureGroup: Identifiable {
    let id = UUID()
    let title: String
    let features: [Feature]
}

/// The sections of the sidebar.
///
/// Only what the SDK actually does on macOS is here. The feedback widgets are
/// guarded to iOS and visionOS in the SDK, so there is no screen for them.
/// Automatic view tracking and device orientation are guarded to iOS and tvOS and
/// appear on the Initialize screen, disabled, so the whole configuration surface
/// stays visible without offering a control that does nothing.
///
/// Every screen below drives the instance the Initialize screen configured, and
/// every call on them is a logged no-op until it has been initialized.
@MainActor
let featureGroups: [FeatureGroup] = [
    FeatureGroup(title: "Setup", features: [
        Feature(title: "Initialize", systemImage: "power", tint: .gray, destination: AnyView(InitView())),
    ]),
    FeatureGroup(title: "Compose", features: [
        Feature(title: "Event Composer", systemImage: "square.and.pencil", tint: .blue, destination: AnyView(EventComposerView())),
        Feature(title: "User Details Editor", systemImage: "person.text.rectangle", tint: .purple, destination: AnyView(UserDetailsComposerView())),
        Feature(title: "Property Modifiers", systemImage: "function", tint: .indigo, destination: AnyView(UserModifiersComposerView())),
    ]),
    FeatureGroup(title: "Data & Events", features: [
        Feature(title: "Custom Events", systemImage: "bolt", tint: .blue, destination: AnyView(CustomEventsView())),
        Feature(title: "Views", systemImage: "rectangle.stack", tint: .teal, destination: AnyView(ViewsView())),
        Feature(title: "Sessions", systemImage: "clock", tint: .indigo, destination: AnyView(SessionsView())),
        Feature(title: "User Profile", systemImage: "person.crop.circle", tint: .purple, destination: AnyView(UserProfileView())),
    ]),
    FeatureGroup(title: "Diagnostics", features: [
        Feature(title: "Crash Reporting", systemImage: "ant", tint: .red, destination: AnyView(CrashReportingView())),
        Feature(title: "Performance", systemImage: "speedometer", tint: .orange, destination: AnyView(APMView())),
    ]),
    FeatureGroup(title: "Engagement", features: [
        Feature(title: "Remote Config", systemImage: "slider.horizontal.3", tint: .cyan, destination: AnyView(RemoteConfigView())),
        Feature(title: "A/B Testing", systemImage: "arrow.triangle.branch", tint: .mint, destination: AnyView(ABTestingView())),
        Feature(title: "Feedback", systemImage: "star.bubble", tint: .yellow, destination: AnyView(FeedbackView())),
        Feature(title: "Content", systemImage: "square.on.square", tint: .pink, destination: AnyView(ContentZoneView())),
        Feature(title: "Push Notifications", systemImage: "bell.badge", tint: .red, destination: AnyView(PushNotificationsView())),
    ]),
    FeatureGroup(title: "Identity & Privacy", features: [
        Feature(title: "Consent", systemImage: "checkmark.shield", tint: .green, destination: AnyView(ConsentView())),
        Feature(title: "Device ID", systemImage: "number", tint: .brown, destination: AnyView(DeviceIDView())),
        Feature(title: "Location", systemImage: "location", tint: .green, destination: AnyView(LocationView())),
        Feature(title: "Attribution", systemImage: "link", tint: .brown, destination: AnyView(AttributionView())),
    ]),
    FeatureGroup(title: "SDK", features: [
        Feature(title: "Requests & Utilities", systemImage: "wrench.and.screwdriver", tint: .gray, destination: AnyView(RequestsUtilitiesView())),
        Feature(title: "Multiple Instances", systemImage: "square.stack.3d.up", tint: .indigo, destination: AnyView(InstancesView())),
        Feature(title: "Multi Threading", systemImage: "cpu", tint: .gray, destination: AnyView(MultiThreadingView())),
    ]),
]
