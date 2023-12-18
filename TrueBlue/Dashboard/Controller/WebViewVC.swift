//
//  WebViewVC.swift
//  TrueBlue
//
//  Created by Vijay Sharma on 02/03/23.
//

import UIKit
import WebKit

class WebViewVC: UIViewController  {
    var url : String?

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(NSURLRequest(url: NSURL(string: url ?? "")! as URL) as URLRequest)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension WebViewVC : UIWebViewDelegate {
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
}
