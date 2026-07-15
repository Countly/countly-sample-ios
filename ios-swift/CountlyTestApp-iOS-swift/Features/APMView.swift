// APMView.swift
import SwiftUI
import Countly

struct APMView: View {
    private let url = URL(string: "https://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json")!
    private var request: URLRequest { URLRequest(url: url) }
    var body: some View {
        Form {
            Section("URLSession") {
                ActionButton("dataTask(with: request)") { URLSession.shared.dataTask(with: request).resume() }
                ActionButton("dataTask(with: request, completion)") { URLSession.shared.dataTask(with: request) { _, _, _ in AppLog.shared.log("dataTask request done") }.resume() }
                ActionButton("dataTask(with: url)") { URLSession.shared.dataTask(with: url).resume() }
                ActionButton("dataTask(with: url, completion)") { URLSession.shared.dataTask(with: url) { _, _, _ in AppLog.shared.log("dataTask url done") }.resume() }
                ActionButton("downloadTask(with: request)") { URLSession.shared.downloadTask(with: request).resume() }
                ActionButton("downloadTask(with: request, completion)") { URLSession.shared.downloadTask(with: request) { _, _, _ in AppLog.shared.log("downloadTask request done") }.resume() }
                ActionButton("downloadTask(with: url)") { URLSession.shared.downloadTask(with: url).resume() }
                ActionButton("downloadTask(with: url, completion)") { URLSession.shared.downloadTask(with: url) { _, _, _ in AppLog.shared.log("downloadTask url done") }.resume() }
            }
            Section("NSURLConnection (legacy Apple API)") {
                ActionButton("sendAsynchronousRequest") {
                    NSURLConnection.sendAsynchronousRequest(request, queue: .main) { _, _, _ in AppLog.shared.log("sendAsynchronousRequest done") }
                }
                ActionButton("init(request:delegate:)") { _ = NSURLConnection(request: request, delegate: APMConnectionDelegate.shared) }
                ActionButton("init(request:delegate:startImmediately:false)") { NSURLConnection(request: request, delegate: APMConnectionDelegate.shared, startImmediately: false)?.start() }
            }
        }
    }
}
