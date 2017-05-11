//
//  JSONDownloader.swift
//  JSONTutorial
//
//  Created by Kapil Amagain on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

struct JSONDownloader {
    //1)
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    init() {
        self.init(configuration: .default)
    }
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (Result<JSON>) -> ()
    
    //4)
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Error(.requestFailed))
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                            DispatchQueue.main.async {
                                completion(.Success(json))
                            }
                        }
                        
                    }
                    catch {
                        completion(.Error(.jsonConversionFailure))
                    }
                } else {
                    completion(.Error(.invalidData))
                }
                } else {
                    completion(.Error(.responseUnsuccessful))
                    print("\(error)")
                }
            }
            return task
        }
  }


enum Result<T> {
    case Success(T)
    case Error(ItunesAPIError)
}
enum ItunesAPIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
}
