// FeedbackView.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import SwiftUI

/// Feedback widgets, which are available on macOS.
///
/// `FeedbackModule` guards its presentation with
/// `os(iOS) || os(visionOS) || os(macOS)`, and the widget page is shown in the
/// same panel overlay the content zone uses. The widget renders its own close
/// control, so nothing here has to dismiss it.
struct FeedbackView: View {
    @State private var nameIDOrTag = ""
    @State private var manualWidgetID = "WIDGET_ID"
    @State private var manualRating = 4

    private var feedback: FeedbackAPI { AppContext.active.feedback }

    /// Empty means "the first widget of that kind the server offers".
    private var lookup: String? {
        let trimmed = nameIDOrTag.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var body: some View {
        FeatureList {
            Section {
                ActionButton("Get Available Feedback Widgets") {
                    feedback.getAvailableFeedbackWidgets { widgets, error in
                        guard let widgets else {
                            return AppLog.shared.log("widget list failed: \(error?.localizedDescription ?? "unknown")")
                        }
                        AppLog.shared.log(widgets.isEmpty
                            ? "no widgets configured for this application"
                            : widgets.map { "\($0.type.wireName): \($0.name)" }.joined(separator: "; "))
                    }
                }
            } header: {
                Text("Available widgets")
            } footer: {
                FootnoteText("Lists what the server offers for this application and device. A widget of a kind this SDK version does not know is left out of the list.")
            }

            Section {
                LabeledField("Name, ID or tag", text: $nameIDOrTag, placeholder: "leave empty for the first one")
                ActionButton("Present NPS") { feedback.presentNPS(lookup) { AppLog.shared.log("NPS widget: \($0)") } }
                ActionButton("Present Survey") { feedback.presentSurvey(lookup) { AppLog.shared.log("survey widget: \($0)") } }
                ActionButton("Present Rating") { feedback.presentRating(lookup) { AppLog.shared.log("rating widget: \($0)") } }
            } header: {
                Text("Present")
            } footer: {
                FootnoteText("With the field empty the SDK presents the first widget of that kind the server offers. The callback reports when the widget appeared and when it closed.")
            }

            Section {
                LabeledField("Widget ID", text: $manualWidgetID)
                Stepper("Rating: \(manualRating)", value: $manualRating, in: 1...5)
                ActionButton("Record a Rating Widget Result Manually") {
                    feedback.recordRatingWidget(id: manualWidgetID,
                                                rating: manualRating,
                                                email: "john@example.com",
                                                comment: "good",
                                                userCanBeContacted: true)
                }
            } header: {
                Text("Manual")
            } footer: {
                FootnoteText("For a rating collected by the application's own interface rather than by a Countly widget.")
            }
        }
    }
}
