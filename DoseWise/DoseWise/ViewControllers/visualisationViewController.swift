//
//  visualisationViewController.swift
//  DoseWise
//
//  Created by 郭成俊 on 30/9/18.
//  Copyright © 2018 Monash. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class visualisationViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url:URL = URL(string: "http://13.211.168.172/")!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
