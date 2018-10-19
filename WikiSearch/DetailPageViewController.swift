//
//  DetailPageViewController.swift
//  WikiSearch
//
//  Created by Karthik on 19/10/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
     let baseURL = "https://en.m.wikipedia.org/?curid="
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "WikiPage"
    }
    
    
    func loadWebView(pageUrl: String) {
        
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(webView)
        self.view.bringSubview(toFront: self.activity)
        webView.delegate = self
        let finalUrlString = baseURL+pageUrl
        let url = NSURL (string: finalUrlString);
        let requestObj = NSURLRequest(url: url! as URL);
        webView.loadRequest(requestObj as URLRequest);
    }
}

extension DetailPageViewController: UIWebViewDelegate{
    // show indicator
    func webViewDidStartLoad(_ webView: UIWebView){
        self.activity.startAnimating()
    }
    // hide indicator
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.activity.stopAnimating()
    }
    // hide indicator
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.activity.stopAnimating()
        if let error = error as NSError? {
            DispatchQueue.main.async {
                AlertController.showAlertToUser( messageTitle: "Error", message: error.localizedDescription, controller: self)
            }
        }
    }

}
