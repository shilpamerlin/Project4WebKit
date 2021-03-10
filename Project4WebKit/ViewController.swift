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
    
    override func loadView() { //loadview get called before viewdidload()
        webView = WKWebView() // create a new instance of Apple's WKWebView web browser component and assign it to the webView property
        webView.navigationDelegate = self
        view = webView //make our view (the root view of the view controller) that web view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //turn the string into a URL, then put the URL into an URLRequest, and WKWebView will load that
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true //a property on the web view that allows users to swipe from the left or right edge to move backward or forward in their web browsing
        
        
    }
    
    @objc func openTapped (){
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
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
    
}


