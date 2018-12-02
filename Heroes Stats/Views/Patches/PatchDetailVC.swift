//
//  PatchDetailVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 22/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import WebKit

class PatchDetailVC: UIViewController, WKUIDelegate, ErrorMessageRenderer {

    var patch: Patch? {
        didSet {
            updateUI()
        }
    }
    
    private var appDelegate: AppDelegate!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        webView = WKWebView(frame: .zero)
        webView.uiDelegate = self
        view = webView
        
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePatch))
        self.navigationItem.rightBarButtonItem = shareBtn
    }
    
    func updateUI() {
        if patch != nil {
            getPatch(url: patch!.url, completion: {
                title, content in
                self.navigationController?.navigationBar.topItem?.title = title
                let css =
"""
    * { font-family: -apple-system;
    font-size: 1.8rem; }
    body {
    padding: 1em
    }
    h1, h1 + div, .official-link { display: none }
    .text-warning {color: orange}

"""
                let newContent = "<html><head><style>\(css)</style></head><body>\(content)</body></html>"
                
                self.webView.loadHTMLString(newContent, baseURL: nil)
            })
        }
    }
    
    @objc func sharePatch() {
        if let link = patch?.url {
        
            let activityController = UIActivityViewController(activityItems: [PATCH_URL + link], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }
}

extension PatchDetailVC: PatchSelectionDelegate {
    func patchSelected(_ newPatch: Patch) {
        patch = newPatch
    }
}
