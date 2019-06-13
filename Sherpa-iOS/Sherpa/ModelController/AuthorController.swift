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
    
    var authorArray = [Author]()
    let filterString: String
    
    init(filterString: String) {
        self.filterString = filterString
        createAuthorModel()
        
    }
    
    // MARK: - Create

  func createAuthorModel() {
        let authorArray = [Author(name: "CloudKit", detail: "Store structured app and user data in iCloud containers that can be shared by all users of your app.", pro: "A discussion on pros of using CloudKit", con: "A discussion on pros of using CloudKit", rating: RatingEnum.three.rawValue, opinion: "My overall opinion of CloudKit is that it can be a great tool to reach all of the users devices. If forces you to become a better Apple programmer by flowing their best practices. It's free! It's organic, you don't need a dependency or cocoapod. Back referencing is convenient for your objects. The CloudKit dashboard is easy to use. However, when working with it, portions of it tend to be slow and feels bulky. It can be tricky working with images (CKAssets) with CloudKit. It's a thick process to fetch images"), Author(name: "CloudKit", detail: "Records are at the heart of all data transactions in CloudKit. A record is a dictionary of key-value pairs that represents the data you want to save.", pro: " Pro: Free! You get 40 requests per second, 2 GB data transfer, 100 MB database storage and 10 GB assets storage.", con: "Fetching images tends to be slow", rating: RatingEnum.three.rawValue, opinion: "Fetching images should take less steps"), Author(name: "CloudKit", detail: "     ", pro: "Forces you to become a better programmer, following Apples best CloudKit practices.", con: "Importing records directly in the dashboard is time consuming", rating: RatingEnum.three.rawValue, opinion: "It would be nice to add multiple records at once in the dashboard."), Author(name: "CloudKit", detail: "Really helpful details through documentation", pro: "The documentation. The CloudKit programing guied is amazing. It's like reading a book!", con: "Wouldn't be safe to set up cross platform.", rating: RatingEnum.three.rawValue, opinion: "I would be nice if they had some starter pojects similar to Firebase."), Author(name: "CloudKit", detail: "Notifications! They work really well with CloudKit.", pro: "APNS push notifications and Subscriptions. APNS integrates nicely with CloudKit. You can subscribe to records and trigger notifications!", con: "Comparing the amount of code from my CloudKit functions to my Firebase functions, there is around 100+ more lines of code with CloudKit.", rating: RatingEnum.three.rawValue, opinion: "I wish notifications worked with simulators!"), Author(name: "CloudKit", detail: "Security", pro: "Apple takes pride in their security which is one of their selling points.", con: "Can't think of a con here!", rating: RatingEnum.three.rawValue, opinion: "I really like how CloudKit subclasses NSOperation. With CKQueryOperation you can set a request limit to incrementally fetch records via the recordFetchedBlock."), Author(name: "CloudKit", detail: "Database and Containers", pro: "You can choose to work with the public DB, shared DB, or the private DB. All three have at least one CKContainer by default. You can have multiple containers within each DB. This creates great flexibility. It also brings up the point of NSPredicates and CKQuerys where you can filter specific data that you'd like to retrieve.", con: "You can't use URLSession, Codable, JSONDecoder to parse because your objects need to be CKRecords.", rating: RatingEnum.three.rawValue, opinion: "CloudKit has a lot of features to work with."), Author(name: "CloudKit", detail: "No Authentication", pro: "CloudKit uses the user's Apple ID, so you don't have to create sign up features.", con: "Doesn't help with Auth for 3rd parties.", rating: RatingEnum.three.rawValue, opinion: "       "), Author(name: "Firebase", detail: "The Firebase Realtime Database is a cloud-hosted NoSQL database that lets you store and sync data between your users in realtime.", pro: "Faster fetching perfromance.", con: "There isn't back referencing to set up parent relationships.", rating: RatingEnum.four.rawValue, opinion: "When working with Firebase Realtime Database it seems to be more light weight than CloudKit. It's really cool how they give you different options of Authentication. Firestore is smooth when saving and fetching images. You can have a property as a image string in your model rather than going through CloudKit's cumbersome process of CKAssets for images. You can import and export JSON directly from Firebase."), Author(name: "Firebase", detail: "Less code.", pro: "In this project, it took less code to set up Firebase.", con: "The documentation is great, however it took me slightly longer to search through Firebase's documentation. As opposed to using Dash or Apple docs for CloudKit", rating: RatingEnum.four.rawValue, opinion: "         "), Author(name: "Firebase", detail: "JSON", pro: "You can use Codable, JSONDecoder with Firebase. You need to architect the backend with different nodes that store uuid's as owners in a dictionary format", con: "It can be tricky using Codable instead of a failable initializer.", rating: RatingEnum.four.rawValue, opinion: "JSON and Snapshots seems to be less bulky than CKRecords"), Author(name: "Firebase", detail: "Notifications", pro: "", con: "CloudKit is easier to subscribe to an object and generate push notifications.", rating: RatingEnum.four.rawValue, opinion: "     "), Author(name: "Firebase", detail: "Example Projects", pro: "Firebase has a Github library of example projects written in both Objective C and Swift. The team continuously updates this repo. It's a great place to see live examples of apps using different features offered by Firebase", con: "     ", rating: RatingEnum.four.rawValue, opinion: "I think that Firebase is a little more intuitive than CloudKit. I really like them both")]
    
    self.authorArray = authorArray
    }
    
    // MARK: - Filter 
    
    func checkDBname(str: String) {
        let selectedDB = authorArray.filter{ $0.matches(searchTerm: str)}.compactMap { $0 as Author}
        self.authorArray = selectedDB
    }

}
