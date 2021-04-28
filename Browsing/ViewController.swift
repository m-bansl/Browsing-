//
//  ViewController.swift
//  Browsing
//
//  Created by Mehak Bansal on 23/04/21.
//

import UIKit
import WebKit

class ViewController: UIViewController{
    
    
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlField.delegate = self
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimateProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        let url = "https://developer.apple.com"
        webView.load(url)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        else if keyPath == "estimateProgress"{
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
        
    }
    
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func reloadPage(_ sender: Any) {
        webView.reload()
    }
    
}

//MARK:-  WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "ERROR DETECTED", message:error.localizedDescription , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        urlField.text = webView.url?.absoluteString
        progressBar.setProgress(0.0, animated: false)
    }
    
}



//MARK:-  UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        if let urlText = textField.text {
            let urlString = "https://" + urlText
            webView.load(urlString)
        }
        return false
        
    }
    
}

// MARK: - WKWebView Extension
extension WKWebView {
    func load(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}


