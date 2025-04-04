//
//  WebView.swift
//  TemplateProject
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import SwiftUI
import WebKit

struct DismissableWebView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let url: URL
    
    var body: some View {
        NavigationView {
            WebView(url: url)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
    }
}

struct WebView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
