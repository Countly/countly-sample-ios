// UserModifiersComposerView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Applies one modifier to a custom property, with the key and value chosen here.
struct UserModifiersComposerView: View {

    enum Modifier: String, CaseIterable, Identifiable {
        case setOnce, increment, incrementBy, multiply, max, min, push, pushUnique, pull
        var id: String { rawValue }

        /// Whether the modifier takes a value at all: increment does not.
        var takesValue: Bool { self != .increment }

        /// Whether the value has to be a number.
        var isNumeric: Bool {
            switch self {
            case .incrementBy, .multiply, .max, .min: return true
            default: return false
            }
        }
    }

    @State private var modifier: Modifier = .incrementBy
    @State private var key = "score"
    @State private var value = "25"

    private var user: UserProfileAPI { AppContext.active.userProfile }

    var body: some View {
        FeatureList {
            Section("Modifier") {
                Picker("Modifier", selection: $modifier) {
                    ForEach(Modifier.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.menu)
            }

            Section {
                LabeledField("Key", text: $key)
                if modifier.takesValue {
                    LabeledField("Value", text: $value)
                }
            } footer: {
                FootnoteText(modifier.isNumeric
                             ? "This modifier needs a number."
                             : modifier.takesValue ? "The value is sent as typed." : "This modifier takes no value.")
            }

            Section {
                Button("Apply") { apply() }
                Button("Save") { user.save(); AppLog.shared.log("saved") }
            } footer: {
                FootnoteText("Modifiers stack up until save is called, so several can be applied to the same property before anything is sent.")
            }
        }
    }

    private func apply() {
        guard !key.isEmpty else { return AppLog.shared.log("a modifier needs a key") }

        if modifier.isNumeric, Double(value) == nil {
            return AppLog.shared.log("\(modifier.rawValue) needs a number, got '\(value)'")
        }
        let number = Double(value) ?? 0

        switch modifier {
        case .setOnce: user.setOnce(key, value: value)
        case .increment: user.increment(key)
        case .incrementBy: user.incrementBy(key, value: number)
        case .multiply: user.multiply(key, value: number)
        case .max: user.max(key, value: number)
        case .min: user.min(key, value: number)
        case .push: user.push(key, value: value)
        case .pushUnique: user.pushUnique(key, value: value)
        case .pull: user.pull(key, value: value)
        }
        AppLog.shared.log("\(modifier.rawValue) on '\(key)'\(modifier.takesValue ? " with '\(value)'" : "")")
    }
}
