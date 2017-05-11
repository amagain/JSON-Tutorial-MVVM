//
//  MovieService.swift
//  JSONTutorial
//
//  Created by Kapil Amagain on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

struct MovieService: Gettable {
    let endPoint: String = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
    let downloader = JSONDownloader()
    //the associated type is inferred by <[Movie?]>
    typealias CurrentWeatherCompletionHandler = (Result<[Movie?]>) -> ()
    
    func get(completion: @escaping CurrentWeatherCompletionHandler) {
        guard let url = URL(string: self.endPoint) else {
            completion(.Error(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = downloader.jsonTask(with: request) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Error(let error):
                    completion(.Error(error))
                    return
                case .Success(let json):
                    guard let movieJSONFeed = json["feed"] as? [String: AnyObject], let entryArray = movieJSONFeed["entry"] as? [[String: AnyObject]] else {
                        completion(.Error(.jsonParsingFailure))
                        return
                    }
                    let movieArray = entryArray.map{Movie(json: $0)}
                    completion(.Success(movieArray))
                }
                
            }
        
        }
        task.resume()
    }
}
protocol Gettable {
    associatedtype T
    func get(completion: @escaping(Result<T>) -> Void)
}
