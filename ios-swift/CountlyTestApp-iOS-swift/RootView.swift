// RootView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(features) { feature in
                    NavigationLink {
                        feature.destination.navigationTitle(feature.title)
                    } label: {
                        Label(feature.title, systemImage: feature.systemImage)
                    }
                }
                StatusBanner()
            }
            .navigationTitle("Countly SDK")
        }
    }
}
