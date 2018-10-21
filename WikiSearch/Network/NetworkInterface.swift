//
//  NetworkInterface.swift
//  WikiSearch
//
//  Created by Karthik on 20/10/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class NetworkInterface: NSObject {
    //Network related call function
    
    static func getPages(searchString : String,completionHandler: @escaping (_ responseObject: AnyObject?, _ count: Int, _ error: NSError?) -> ()) {
        
        let searchStringWithoutSpace = searchString.replacingOccurrences(of: " ", with: "_")
        let baseUrl = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch="
        
        let URL_FINAL = String(format: "%@%@%@", baseUrl,searchStringWithoutSpace,"&gpslimit=10")

        
        let url = URL(string: URL_FINAL)
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
            
            if let error = error as NSError?, error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                let pageList = [Page]()
                completionHandler(pageList as [AnyObject] as AnyObject, pageList.count, error)
                return
            }else{
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    if let query = jsonObj!.value(forKey: "query") as? NSDictionary {
                        var pageList = [Page]()
                        if let pages = query.value(forKey: "pages")as? NSArray {
                           PersistantService.deleteAllEntries()
                            for item in pages{
                                let itemAtIndex = Page.getPageFromJson(json: item as! [String : Any])
                                pageList.append(itemAtIndex)
                               PersistantService.savePage(page: itemAtIndex)
                            }
                            completionHandler(pageList as AnyObject, pageList.count, nil)
                        }
                    }
                }
                
            }
            
        }).resume()

    }
    
    
}
