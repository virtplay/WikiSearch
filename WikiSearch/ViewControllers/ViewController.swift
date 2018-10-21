//
//  ViewController.swift
//  WikiSearch
//
//  Created by Karthik on 20/10/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!  // table view
    @IBOutlet weak var searchBar: UISearchBar!  // search bar
    
    
    var pageListArray = [WikiPage]()  // Array to store coredata content
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSearchbar()
    }
    
    private func setupSearchbar(){
        searchBar.delegate = self
    }
    
    //Call web request here.
    func getPages(searchString: String)  {
        
        NetworkInterface.getPages(searchString: searchString) { (responseData, count, error) in
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    AlertController.showAlertToUser( messageTitle: "Error", message: error.localizedDescription, controller: self)
                }
            }
            self.loadTable()
        }
    }
    
    func loadTable() {
        self.pageListArray = PersistantService.getSavedPageList()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UISearchBarDelegate{
    
    // Search bar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // If we haven't typed anything into the search bar then do not filter the results
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        print("searchText")
        self.getPages(searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
    
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableCell else{
            return UITableViewCell()
        }
        
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        
        imageViewCornerRadius(profileImage: cell.imgView)
        
        let pageAtIndex = pageListArray[indexPath.row]
        if let pageTitle = pageAtIndex.title {
            cell.title.text = pageTitle
        }else{
            cell.title.text = "No title available"
        }
        if let pageDesc = pageAtIndex.desc {
            cell.detail.text = pageDesc
        }else{
            cell.detail.text = "No Description available"
        }
        
        if pageAtIndex.image_url != nil {
            if pageAtIndex.image != nil{
                cell.imgView.image = UIImage(data: pageAtIndex.image!)
            }else{
                let url = URL(string: pageAtIndex.image_url!)
                let data = try? Data(contentsOf: url!)   // download thumbnail for image url
                cell.imgView.image = UIImage(data: data!)
            }
        }
        else{
            cell.imgView.image = UIImage(named: "placeholder.png")
            cell.imageView?.contentMode = .scaleToFill
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageListArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPage = pageListArray[indexPath.row]
        if let pageID = selectedPage.id {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let detailPageControllerObj = storyBoard.instantiateViewController(withIdentifier: "DetailPageViewController") as! DetailPageViewController
            detailPageControllerObj.loadWebView(pageUrl: pageID)
            self.navigationController?.pushViewController(detailPageControllerObj, animated: true)
            
        }else{
            AlertController.showAlertToUser(messageTitle: "Error", message: "Detail not found", controller: self)
        }
    }
    
    func imageViewCornerRadius(profileImage: UIImageView)
    {
        profileImage.layer.cornerRadius = 16.0
        profileImage.layer.masksToBounds = true
        
    }
    
}


