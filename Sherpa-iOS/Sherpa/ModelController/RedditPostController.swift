//
//  RedditPostController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/30/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class RedditPostController {
    
    // TODO: -  swap out with DI
    static let shared = RedditPostController()
    
    // MARK: - Properties
    
    private let baseURL = URL(string: "https://www.reddit.com/r/all/hot")
    var posts = [RDPost]()
    var nextUrl: String?
    typealias PostCompletionHandler = ([RDPost]?, NetworkError?) -> Void
    
    // MARK: - Functions
    
    func fetchPost(completion: @escaping PostCompletionHandler) {
        guard let url = baseURL else { completion(nil,.invalidUrl); return }
        let jsonUrl = url.appendingPathExtension("json")
        
        // TODO: Delete NetworkManager and Networking Layer 
        NetworkManager.performRequest(for: jsonUrl, httpMethod: .get, body: nil) { (data, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw NSError() }
                
                let postDictionaries = try JSONDecoder().decode(JsonDictionary.self, from: data)
                let nextUrl = postDictionaries.data.after
                let posts = postDictionaries.data.children.compactMap{$0.data}
                
                self.nextUrl = nextUrl
                self.posts = posts
                completion(posts, nil)
                
            } catch let error {
                print("Error fetching post \(error.localizedDescription) \(error) \(#function)")
                completion(nil,.jsonConversionFailure)
            }
        }
    }
    
    func fetchNextPagePosts(completion: @escaping PostCompletionHandler) {
        let jsonUrl = "https:/www.reddit.com/r/all/hot.json?after="
        guard let nextUrl = nextUrl else { return }
        guard let url = URL(string: jsonUrl + nextUrl) else { return }
        
        NetworkManager.performRequest(for: url, httpMethod: .get, body: nil) { (data, error) in
            
            do {
                if let error = error { throw error}
                guard let data = data else { throw NSError() }
                
                let postDictionaries = try JSONDecoder().decode(JsonDictionary.self, from: data)
                let nextUrl = postDictionaries.data.after
                let newPosts = postDictionaries.data.children.compactMap{$0.data}
                
                self.nextUrl = nextUrl
                self.posts.append(contentsOf: newPosts)
                
                completion(self.posts, nil)
                
            } catch let error {
                print("Error fetching next page \(error.localizedDescription) \(error) \(#function)")
                completion(nil,.jsonConversionFailure)
            }
        }
    }
    
    func fetchThumbnail(rdPost: RDPost, completion: @escaping (UIImage?, NetworkError?) -> Void) {
        guard let postThumbnail = rdPost.thumbnail, let imageUrl = URL(string: postThumbnail) else { return }
        
        NetworkManager.performRequest(for: imageUrl, httpMethod: .get, body: nil) { (data, error) in
            
            do {
                if let error = error { throw error }
                guard let data = data else { throw NSError() }
                
                let image = UIImage(data: data)
                completion(image, nil)
                
            } catch let error {
                print("Error fetching thumbnail from task \(error.localizedDescription) \(error) \(#function)")
                completion(nil, .imageDataFailure)
            }
        }
    }
}
