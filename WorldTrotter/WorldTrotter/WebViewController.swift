//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Nicholas Mahlangu on 1/21/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func loadView() {
        
        super.viewDidLoad()
        
        // Create a web view and set it as this controller's view
        webView = WKWebView()
        view = webView
        
        // constraints
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height,width])
    
        // load page
        let url = NSURL(string:"https://www.bignerdranch.com")
        let req = NSURLRequest(URL: url!)
        webView.loadRequest(req)
    }
}


