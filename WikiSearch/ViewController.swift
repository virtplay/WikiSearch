//
//  ViewController.swift
//  WikiSearch
//
//  Created by Karthik on 19/10/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!  // table view
    @IBOutlet weak var searchBar: UISearchBar!  // search bar
    
    
    var pageListArray = [WikiPage]()  // Data from coredata
//    var filteredArray = [WikiPage]()  // filtered data array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        setupWikiData()
        registerForKeyBoardNotification()
        setupSearchbar()
    }
    
    private func registerForKeyBoardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("notification: Keyboard will show")
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
    
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableCell else{
            return UITableViewCell()
        }
        //        cell.country =
        //        cell.detail =
        //        cell.imgView =
        
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
        
//        if let imageURL = pageAtIndex.image_url {
//            cell.imgView?.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder.png"))
//        }else{
            cell.imageView?.image = UIImage(named: "placeholder.png")
//        }
        cell.imageView?.contentMode = .scaleAspectFit
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageListArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
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
    
}


