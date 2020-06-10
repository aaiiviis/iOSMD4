//
//  OpenWebViewController.swift
//  4MD
//
//  Created by Aivis Skangalis 10.06.2020.
//  Copyright © 2020.g. Aivis Skangalis. All rights reserved.
//

import UIKit
import WebKit

class OpenWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    var filePath: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        //activity.isHidden = true
        webView.navigationDelegate = self
        if let fileName = title {
            openFile(filePath ?? "Error: No file path set")
            print("File ", fileName, " opened")
        } else {
            print("Nothing to open")
        }
    }
    
    private func openFile(_ fileName: String) {
        let url: URL = URL(fileURLWithPath: fileName)
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
}
