// RootView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationView {
                sidebar
                placeholder
            }
            Divider()
            LogPane()
        }
    }

    private var sidebar: some View {
        List {
            ForEach(featureGroups) { group in
                Section(header: Text(group.title)) {
                    ForEach(group.features) { feature in
                        NavigationLink {
                            FeatureDetail(feature: feature)
                        } label: {
                            Label {
                                Text(feature.title)
                            } icon: {
                                Image(systemName: feature.systemImage)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 22, height: 22)
                                    .background(feature.tint, in: RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 230)
    }

    private var placeholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 34))
                .foregroundStyle(.tertiary)
            Text("Countly Swift SDK v\(SDKIdentity.version)")
                .font(.headline)
            Text("Start on Initialize: the SDK is not started at launch, so every init-time option is chosen there before anything runs. Everything the other screens call, and everything the SDK says back, lands in the log below.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 380)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// One feature screen, titled and given a sensible minimum width.
private struct FeatureDetail: View {
    let feature: Feature

    var body: some View {
        feature.destination
            .frame(minWidth: 480)
            .navigationTitle(feature.title)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Text("v\(SDKIdentity.version)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
    }
}
