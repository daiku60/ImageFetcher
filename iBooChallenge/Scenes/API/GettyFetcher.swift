//
//  File.swift
//  iBooChallenge
//
//  Created by Jordi Serra i Font on 19/2/17.
//  Copyright © 2017 kudai. All rights reserved.
//

import Foundation
import Deferred

enum HTTPMethods: String {
    case get
    case post
}

enum FetcherError: Error {
    case parseError
    case unknown
}

enum GettyCall: String {
    case search = "search/images"
}

protocol ImagesListFetcher {
    func fetchImages(withSearchTerm: String, page: Int, pageSize: Int) -> Task<[String: Any]>
}

class GettyFetcher: ImagesListFetcher {
    
    private var apiKey = "bejfn9r4rj22dmzsntvbzxc9"
    private var baseURL = "https://api.gettyimages.com/v3/"
    
    public func retrieveGetty(withAPICall call: GettyCall, params: [String: Any] = [:]) -> Task<[String: Any]> {
        
        let deferred = Deferred<TaskResult<[String: Any]>>()
        
        let paramsStr = params.stringFromHttpParameters()
        guard let url = URL(string: "\(baseURL)\(call.rawValue)?\(paramsStr)") else {
            fatalError()
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "Api-Key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                deferred.fill(with: .failure(error))
            }
            
            guard let data = data,
                  let jsonData = try? JSONSerialization.jsonObject(with: data),
                  let json = jsonData as? [String: Any] else {
                deferred.fill(with: .failure(FetcherError.parseError))
                return
            }
            
            deferred.fill(with: .success(json))

        }.resume()
        
        return Task(future: Future(deferred))
    }
    
    func fetchImages(withSearchTerm term: String, page: Int = 0, pageSize: Int = 20) -> Task<[String: Any]> {
        return retrieveGetty(withAPICall: .search, params: ["phrase": term, "page": page, "page_size": pageSize])
    }
}

extension String {
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue: String = {
                if let valueStr = value as? String {
                    return valueStr.addingPercentEncodingForURLQueryValue()!
                } else if let valueInt = value as? Int {
                    return "\(valueInt)".addingPercentEncodingForURLQueryValue()!
                } else {
                    fatalError()
                }
            }()
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
