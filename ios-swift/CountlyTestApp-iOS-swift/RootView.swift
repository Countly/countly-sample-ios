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
                List {
                    ForEach(featureGroups) { group in
                        Section(group.title) {
                            ForEach(group.features) { feature in
                                NavigationLink {
                                    feature.destination.navigationTitle(feature.title)
                                } label: {
                                    Label {
                                        Text(feature.title)
                                    } icon: {
                                        Image(systemName: feature.systemImage)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(.white)
                                            .frame(width: 28, height: 28)
                                            .background(feature.tint, in: RoundedRectangle(cornerRadius: 7))
                                    }
                                }
                            }
                        }
                    }
                }
                StatusBanner()
            }
            .navigationTitle("Countly")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("v\(SDKIdentity.version)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
