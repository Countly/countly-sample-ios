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
    var keyboard: UIKeyboardType = .default
    var placeholder: String = ""

    init(_ label: String, text: Binding<String>, keyboard: UIKeyboardType = .default, placeholder: String = "") {
        self.label = label
        self._text = text
        self.keyboard = keyboard
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 108, alignment: .leading)
            TextField(placeholder.isEmpty ? label : placeholder, text: $text)
                .keyboardType(keyboard)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .multilineTextAlignment(.trailing)
        }
    }
}

/// An add-and-remove list of key and value pairs.
struct KeyValueEditor: View {
    let title: String
    @Binding var pairs: [KeyValue]

    var body: some View {
        Section {
            ForEach($pairs) { $pair in
                HStack {
                    TextField("key", text: $pair.key)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    Divider()
                    TextField("value", text: $pair.value)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                }
            }
            .onDelete { pairs.remove(atOffsets: $0) }

            Button {
                pairs.append(KeyValue(key: "", value: ""))
            } label: {
                Label("Add a pair", systemImage: "plus.circle")
            }
        } header: {
            Text(title)
        } footer: {
            Text("A value that looks like a number or a boolean is sent as one; everything else is sent as text. Swipe a row to remove it.")
        }
    }
}
