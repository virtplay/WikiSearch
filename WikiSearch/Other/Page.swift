//
//  Page.swift
//  WikiSearch
//
//  Created by Karthik on 20/10/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class Page: NSObject {
    
    var pageID : String?
    var pageTitle : String?
    var pageDescription : String?
    var pageImageUrl : String?
    var pageData : Data?
    
    //Parse json and get page
    static func getPageFromJson(json:[String:Any])-> Page{

        let page = Page()
        if let title = json["title"] as? String{
            page.pageTitle = title
        }

        if let pageid = (json["pageid"] as? NSNumber) {
            let pageIDString = "\(pageid)"
            page.pageID =  pageIDString
        }

        if let thumbnail = json["thumbnail"] as? NSDictionary {
            if let imageurl = thumbnail["source"] as? String {
                page.pageImageUrl = imageurl
            }
        }
        
        if let thumbnail_img = json["thumbnail"] as? NSDictionary {
            if let imageurl = thumbnail_img["source"] as? String {
                let url = URL(string: imageurl)
                let data = try? Data(contentsOf: url!)
                page.pageData = data
            }
        }
        

        if let terms = json["terms"] as? NSDictionary {
            if let descriptionArray = terms["description"] as? NSArray {
                if let descriptionText = descriptionArray[0] as? String {
                    page.pageDescription = descriptionText
                }
            }
        }

        return page

    }
    

}
