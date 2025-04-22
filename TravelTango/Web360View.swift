import SwiftUI
import WebKit

struct Web360View: UIViewRepresentable {
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        // Load the HTML file from the root of the app bundle
        if let htmlPath = Bundle.main.path(forResource: "panorama", ofType: "html") {
            print("✅ Found panorama.html at path: \(htmlPath)")
            let htmlUrl = URL(fileURLWithPath: htmlPath)
            let baseUrl = htmlUrl.deletingLastPathComponent()
            if let htmlString = try? String(contentsOfFile: htmlPath, encoding: .utf8) {
                webView.loadHTMLString(htmlString, baseURL: baseUrl)
            } else {
                print("❌ Failed to load HTML string")
            }
        } else {
            print("❌ panorama.html not found in root bundle")
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Web360View

        init(parent: Web360View) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            print("❌ Web view failed: \(error.localizedDescription)")
        }
    }
}

