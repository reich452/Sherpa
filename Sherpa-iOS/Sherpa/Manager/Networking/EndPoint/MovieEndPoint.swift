//
//  MovieEndPoint.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/7/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum MovieApi {
    case recommended(id: Int)
    case popular(page: Int)
    case newMovies(page: Int)
    case video(id: Int)
    case imageData(str: String)
  
    func apiKey() -> String {
        return "c7b1811db3e27e7c2623fd449aa25310"
    }
    
    func imageURL() -> URL {
        return URL(string: "https://image.tmdb.org/t/p/w500")!
    }
}

extension MovieApi: ServiceProtocol {
    
    var environmentBaseURL : String {
        switch MovieController.environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .qa: return "https://qa.themoviedb.org/3/movie/"
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var baseImageURL: URL {
       return imageURL()
    }
    
    var path: String {
        switch self {
        case .recommended(let id):
            return "\(id)/recommendations"
        case .popular:
            return "popular"
        case .newMovies:
            return "now_playing"
        case .video(let id):
            return "\(id)/videos"
        case .imageData(let imageStr):
            return imageURL().absoluteString + imageStr
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "api_key": self.apiKey()])
        case .popular(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page":page,
                                                      "api_key": self.apiKey()])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
