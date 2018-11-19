//
//  CoreDataController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/14/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import CoreData

class AuthorController {
    
    let filterString: String

    init(filterString: String) {
      
        self.filterString = filterString
        authorArray = createAuthorModel()
    }
    
    var authorArray = [AuthorModel]()
    
    func createAuthorModel() -> [AuthorModel] {
        let authorArray = [AuthorModel(name: "CloudKit", detail: "Store structured app and user data in iCloud containers that can be shared by all users of your app.", pro: "", con: "", rating: RatingEnum.three.rawValue, opinion: "My overall opinion of CloudKit is that it can be a great tool to reach all of the users devices. If forces you to become a better Apple programmer by flowing their best practices. It's free! It's orgatic, you don't need a dependency or cocoapod. Back referencing is convenient for your objects. The CloudKit dashboard is easy to use. However, when working with it, protions of it tend to be slow and feels bulkey. It can be tricky working with images (CKAssets) with CloudKit. It's a thick proccess to fetch images"), AuthorModel(name: "CloudKit", detail: "Records are at the heart of all data transactions in CloudKit. A record is a dictionary of key-value pairs that represents the data you want to save.", pro: "Free! You get 40 requests per second, 2 GB data transfer, 100 MB database storage and 10 GB assets storage.", con: "Fetching images tends to be slow", rating: RatingEnum.three.rawValue, opinion: "Fetching images should take less steps"), AuthorModel(name: "CloudKit", detail: "", pro: "Forces you to become a better programmer, following Apples best CloudKit practices.", con: "Importing records directly in the dashboard is time consuming", rating: RatingEnum.three.rawValue, opinion: "It would be nice to add multiple records at once in the dashboard."), AuthorModel(name: "CloudKit", detail: "", pro: "Great documentation. The CloudKit programing guied is amazing. Its like reading a book!", con: "Wouldn't be safe to set up cross platform.", rating: RatingEnum.three.rawValue, opinion: ""), AuthorModel(name: "CloudKit", detail: "Notifications!", pro: "APNS push notifications and Subscriptions. APNS inegrates nicly with CloudKit. You can subscribe to records and trigger notifications!", con: "Comparing the amount of code from my CloudKit functions to my Firebase functions, there is around 100+ more lines of code with CloudKit.", rating: RatingEnum.three.rawValue, opinion: ""), AuthorModel(name: "CloudKit", detail: "Security", pro: "Apple takes pride in their security which is one of their selling points.", con: "", rating: RatingEnum.three.rawValue, opinion: "I really like how CloudKit subclasses NSOperation. With CKQueryOperation you can set a request limit to incrementally fetch records via the recordFetchedBlock."), AuthorModel(name: "CloudKit", detail: "Database and Containers", pro: "You can choose to work with the public DB, shared DB, or the private DB. All three have at least one CKContainer by default. You can have multiple containers within each DB. This creates great flexiblity. It also brings up the point of NSPredicates and CKQuerys where you can filter specific data that you'd like to retrieve.", con: "You can't use URLSession, Codable, JSONDecoder to parse because your objects need to be CKRecords.", rating: RatingEnum.three.rawValue, opinion: "CloudKit has a lot of features to work with."), AuthorModel(name: "CloudKit", detail: "No Authentication", pro: "CloudKit uses the user's Apple ID, so you don't have to create sign up features.", con: "Doesn't help with Auth for 3rd parties.", rating: RatingEnum.three.rawValue, opinion: ""), AuthorModel(name: "Firebase", detail: "The Firebase Realtime Database is a cloud-hosted NoSQL database that lets you store and sync data between your users in realtime.", pro: "Faster fetching perfromance.", con: "There isn't back referencing to set up parent relationships.", rating: RatingEnum.four.rawValue, opinion: "When working with Firebase Realtime Database it seems to be more light weight than CloudKit. It's really cool how they give you different options of Authentication. Firestore is smooth when saving and fetching images. You can have a property as a image string in your model rather than going through CloudKit's cumbersome process of CKAssets for images. You can import and export JSON directly from Firebase."), AuthorModel(name: "Firebase", detail: "Less code.", pro: "In this project, it took less code to set up Firebase.", con: "The documentation is great, however it took me slightly longer to search through Firebase's documentation. As opposed to using Dash or Apple docs for CloudKit", rating: RatingEnum.four.rawValue, opinion: ""), AuthorModel(name: "Firebase", detail: "JSON", pro: "You can use Codable, JSONDecoder with Firebase. You need to architect the backend with different nodes that store uuid's as owners in a dictionary format", con: "", rating: RatingEnum.four.rawValue, opinion: "JSON and Snapshots seems to be less bulkey than CKRecords"), AuthorModel(name: "Firebase", detail: "Notifications", pro: "", con: "CloudKit is easier to subscribe to an object and generate push notifications.", rating: RatingEnum.four.rawValue, opinion: ""), AuthorModel(name: "Firebase", detail: "Example Projects", pro: "Firebase has a Github library of example projects written in both Objective C and Swift. The team continuously updates this repo. It's a great place to see live examples of apps using different features offered by Firebase", con: "", rating: RatingEnum.four.rawValue, opinion: "I think that Firebase is a little more intuitive than CloudKit. I really like them both")]
        for author in authorArray {
            author.managedObjectContext?.insert(author)
        }
        return authorArray
    }
    
    // MARK: - Filter
    
    func checkFilter() {
        if filterString == "CloudKit" {
            filterCloudKit()
        } else {
            filterFirebase()
        }
    }
    
   private func filterCloudKit() {
        
        let fetchRequest = NSFetchRequest<AuthorModel>(entityName: "AuthorModel")
        fetchRequest.predicate = NSPredicate(format: "name BEGINSWITH %@", "CloudKit")
        
        do {
            authorArray = try CoreDataStack.context.fetch(fetchRequest)
        } catch let error {
            print("Could not fetch coredata cloudKit \(error) \(error.localizedDescription)")
        }
    }
    
   private func filterFirebase() {
        let fetchRequest = NSFetchRequest<AuthorModel>(entityName: "AuthorModel")
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", "Firebase")
        
        do {
            authorArray = try CoreDataStack.context.fetch(fetchRequest)
        } catch let error {
            print("Could not fetch coredata firebase \(error) \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save
    func save() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch let error {
            print("Error saving to CoreData: \(#function) \(error) \(error.localizedDescription)")
        }
    }

}
