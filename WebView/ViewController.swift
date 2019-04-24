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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))

        openPage()
    }
    
    @objc fileprivate func handleSearch() {
        let ac = UIAlertController(title: "Open?", message: "Pick a website", preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        ac.addAction(UIAlertAction(title: "Apple", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Google", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    fileprivate func openPage(action: UIAlertAction? = nil) {
        var urlString = "Google"
        
        if let action = action {
            urlString = "https://www.\(action.title?.lowercased() ?? "google").com"
        } else {
            urlString = "https://www.google.com"
        }
        
        navigationItem.title = urlString
        
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
}

