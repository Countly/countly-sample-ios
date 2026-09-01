// ComposerSupport.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// One editable key and value, for the screens that let a tester build a
/// segmentation or a set of custom properties by hand.
struct KeyValue: Identifiable, Equatable {
    let id = UUID()
    var key: String
    var value: String

    /// The value as the SDK will receive it.
    ///
    /// A segmentation value that looks like a number or a boolean is sent as one,
    /// because that is what the server needs in order to aggregate it. Anything
    /// else goes as a string.
    var typedValue: Any {
        if let integer = Int(value) { return integer }
        if let double = Double(value) { return double }
        switch value.lowercased() {
        case "true", "yes": return true
        case "false", "no": return false
        default: return value
        }
    }
}

/// A labelled text field, so the composer forms read as forms rather than as a
/// column of anonymous boxes.
struct LabeledField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""

    init(_ label: String, text: Binding<String>, placeholder: String = "") {
        self.label = label
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 130, alignment: .leading)
            TextField(placeholder.isEmpty ? label : placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
        }
    }
}

/// An add-and-remove list of key and value pairs.
///
/// A row carries its own remove button rather than relying on a swipe, which a
/// pointer-driven list has no equivalent of.
struct KeyValueEditor: View {
    let title: String
    @Binding var pairs: [KeyValue]

    var body: some View {
        Section {
            ForEach($pairs) { $pair in
                HStack(spacing: 6) {
                    TextField("key", text: $pair.key)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    TextField("value", text: $pair.value)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                    Button {
                        pairs.removeAll { $0.id == pair.id }
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .buttonStyle(.borderless)
                    .help("Remove this pair")
                }
            }

            Button {
                pairs.append(KeyValue(key: "", value: ""))
            } label: {
                Label("Add a pair", systemImage: "plus.circle")
            }
            .buttonStyle(.borderless)
        } header: {
            Text(title)
        } footer: {
            Text("A value that looks like a number or a boolean is sent as one; everything else is sent as text.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

/// Turns the filled-in rows into what the SDK takes, or `nil` when there are none.
func segmentationDictionary(from pairs: [KeyValue]) -> [String: Any]? {
    let filled = pairs.filter { !$0.key.isEmpty }
    guard !filled.isEmpty else { return nil }
    return Dictionary(filled.map { ($0.key, $0.typedValue) }, uniquingKeysWith: { _, last in last })
}

/// The container every feature screen uses.
///
/// A `List` rather than a `Form`: on macOS a form does not scroll on its own, and
/// several of these screens are longer than a window.
struct FeatureList<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        List {
            content
        }
        .listStyle(.inset)
    }
}

/// Explanatory text under a section, matching the iOS sample's section footers.
struct FootnoteText: View {
    let text: String

    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}
