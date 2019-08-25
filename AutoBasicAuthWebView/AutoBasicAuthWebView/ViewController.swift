//
//  ViewController.swift
//  AutoBasicAuthWebView
//
//  Created by Ryu Kikkawa on 2019/08/24.
//  Copyright © 2019 Ryu Kikkawa. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegate.
        self.webview.navigationDelegate = self
        
        // Set request url.
        let url = URL(string:"http://leggiero.sakura.ne.jp/xxxxbasic_auth_testxxxx/secret/kaiin_page_top.htm")!
        let request = URLRequest(url: url)
        
        // Start request.
        self.webview.load(request)
        
    }


}

extension ViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodHTTPBasic:
            // Basic authrization
            
            let filePath = Bundle.main.path(forResource: "settings", ofType:"plist" )
            let plist = NSDictionary(contentsOfFile: filePath!)
            
            let authTest = plist?.value(forKey: "Auth Test")! as! NSDictionary
            let authUser = authTest.value(forKey: "Basic Auth User")! as! String
            let authPassword = authTest.value(forKey: "Basic Auth Password")! as! String
            
            let credential = URLCredential(user: authUser, password: authPassword, persistence: URLCredential.Persistence.forSession)
            completionHandler(.useCredential, credential)
            
        default:
            completionHandler(.performDefaultHandling, nil)
        }
        
    }
    
}

