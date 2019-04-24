//
//  ViewController.swift
//  WebView
//
//  Created by Prudhvi Gadiraju on 4/23/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "google.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        view = webView
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        // Tool Bar
        let progress = UIBarButtonItem(customView: progressView)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefresh))
        toolbarItems = [progress, space, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))

        openPage()
        

    }
    
    @objc fileprivate func handleSearch() {
        let ac = UIAlertController(title: "Open?", message: "Pick a website", preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    fileprivate func openPage(action: UIAlertAction? = nil) {
        var urlString = "Google"
        
        if let action = action {
            urlString = "https://www.\(action.title?.lowercased() ?? "google")"
        } else {
            urlString = "https://www.google.com"
        }
        
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webView.title
    }
    
    @objc fileprivate func handleRefresh() {
        webView.reload()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}

