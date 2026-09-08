// RootView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RootView: View {
    @ObservedObject private var session = SDKSession.shared

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if session.isInitialized {
                    List {
                        Section {
                            ForEach(features) { feature in
                                NavigationLink {
                                    feature.destination.navigationTitle(feature.title)
                                } label: {
                                    Label(feature.title, systemImage: feature.systemImage)
                                }
                            }
                        } header: {
                            Text("\(session.activeHost ?? "") · \(session.activeAppKey ?? "")")
                                .textCase(nil)
                        }
                    }
                } else {
                    SetupView()
                }
                StatusBanner()
            }
            .navigationTitle(session.isInitialized ? "Countly SDK" : "Countly SDK Setup")
        }
    }
}
