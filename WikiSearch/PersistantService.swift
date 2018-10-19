//
//  PersistantService.swift
//  WikiSearch
//
//  Created by Karthik on 19/10/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import Foundation
import CoreData

class PersistantService {
    
    static var context : NSManagedObjectContext = persistentContainer.viewContext


    private init(){
    
    }
    //Call this function to save a page to core data
    static func savePage(page: Page){
        
        let itemToSave: WikiPage = NSEntityDescription.insertNewObject(forEntityName: "WikiPage", into: context) as! WikiPage
        
        itemToSave.title = page.pageTitle 
        itemToSave.id = page.pageID
        itemToSave.image_url = page.pageImageUrl
        itemToSave.desc = page.pageDescription
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    //Function to get saved page list from core data
    static func getSavedPageList()->[WikiPage] {
        
        let fetchRequest = NSFetchRequest<WikiPage>(entityName: "WikiPage")
        var wikipageArray = [WikiPage]()
        
        do {
            wikipageArray = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return wikipageArray
    }
    
    //Call this function to delete already added entries from core data
    static func deleteAllEntries() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "WikiPage")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
