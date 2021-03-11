//
//  ViewController.swift
//  Project4WebKit
//
//  Created by Shilpa Joy on 2021-03-10.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() { //loadview get called before viewdidload()
        webView = WKWebView() // create a new instance of Apple's WKWebView web browser component and assign it to the webView property
        webView.navigationDelegate = self
        view = webView //make our view (the root view of the view controller) that web view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
       let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backBtn = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardBtn = UIBarButtonItem(title: "Forward", style: .plain,target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [backBtn,forwardBtn, progressButton,spacer,refresh]
        navigationController?.isToolbarHidden = false
        
        //turn the string into a URL, then put the URL into an URLRequest, and WKWebView will load that
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true //a property on the web view that allows users to swipe from the left or right edge to move backward or forward in their web browsing
    }
    
    @objc func openTapped (){
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        /*ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))*/
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        let url = URL(string: "https://" + action.title!)!  //use the title property of the action (apple.com, hackingwithswift.com), put "https://"
        
        //It then wraps that inside an URLRequest, and gives it to the web view to load
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)  {
        let url = navigationAction.request.url //we set the constant url to be equal to the URL of the navigation

        if let host = url?.host { //"if there is a host for this URL, pull it out" – and by "host" it means "website domain"
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
                let ac = UIAlertController(title: "Blocked", message: "Blocked due to security concerns", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                print("not allowed")
                present(ac, animated: true)
            
        }

        decisionHandler(.cancel)
    }
}


