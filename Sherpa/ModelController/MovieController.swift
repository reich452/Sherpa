//
//  MovieController.swift
//  Sherpa
//
//  Created by Nick Reichard on 4/16/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import UIKit

final class MovieController {
    
    static let environment : NetworkEnvironment = .production
    let router = Router<MovieApi>()
   
    typealias MovieCompletion = (Result<[Movie]?, Error>) ->()
    
    func getNewMovies(page: Int, completion: @escaping MovieCompletion){
        router.request(.newMovies(page: page)) { data, response, error in
            self.handelData(data: data, response: response, error: error, completion: { result in
                switch result {
                case .success(let movies):
                    guard let movies = movies else { return }
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    func getTopRated(page: Int, completion: @escaping MovieCompletion) {
        router.request(.popular(page: page)) {  (data, response, error) in
            self.handelData(data: data, response: response, error: error, completion: { result in
                switch result {
                case .success(let movies):
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    func getRecommended(page: Int, completion: @escaping MovieCompletion) {
        router.request(.recommended(id: page)) {  (data, response, error) in
            self.handelData(data: data, response: response, error: error, completion: { result in
                switch result {
                case .success(let moives):
                    completion(.success(moives))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    func fetchImageFrom(movies: [Movie], completion: @escaping ([Movie]) -> ()) {
        let group = DispatchGroup()
        var updatedMovies: [Movie] = []
        for movie in movies {
            var movie = movie
            if let posterPath = movie.posterPath {
                group.enter()
                router.fetchImageData(.imageData(str: posterPath), imageStr: posterPath) { (data, response, error) in
                    if let error = error {
                        debugPrint("Error getting image \(error) \(error.localizedDescription)")
                    }
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }
                    movie.image = image
                    updatedMovies.append(movie)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
             completion(updatedMovies)
        }
    }

    fileprivate func handelData(data: Data?, response: URLResponse?, error: Error?, completion: @escaping MovieCompletion) {

        guard let response = response else { completion(.failure(NetworkError.badRequest)); return }
        NetworkLogger.log(response: response)
        //this is not an API failure. Such failures are client side and will probably be due to a poor internet connection.
        if let error = error {
            debugPrint("Check your network connection \n\n \(error) \(error.localizedDescription)")
            completion(.failure(error))
        }
        guard let data = data else { completion(.failure(NetworkError.noDataReturned)); return }
        
        do {
            let moives = try JSONDecoder().decode(MovieApiResponse.self, from: data).movies
            completion(.success(moives))
        } catch let error {
            debugPrint("Error with JSONDecoder object \(error) \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, Error> {
        switch response.statusCode {
        case 200...299: return .success(response.statusCode)
        case 401...500: return .failure(NetworkError.authentication)
        case 501...599: return .failure(NetworkError.badRequest)
        case 600: return .failure(NetworkError.outdated)
        default: return .failure(NetworkError.forwardedString(errorString: "Failure. check original error"))
        }
    }
}
