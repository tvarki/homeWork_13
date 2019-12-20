//
//  NetModel.swift
//  homeWork_13
//
//  Created by Дмитрий Яковлев on 20.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
    case HEAD
    // другие
}

enum Result<T> {
    case some(object: T)
    case error(description: String)
}

class NetModel {

    let baseURL = "https://jsonplaceholder.typicode.com"    
    func sendRequest<T: Encodable, U: Decodable>(
        endPoint: String,
        httpMethod: HTTPMethod = .GET,
        headers: [String: String],
        model: T ,
        parseType: U.Type,
        completion: @escaping (Result<U>) -> Void
    ) {
        let urlString = baseURL + endPoint
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        if httpMethod == .POST{
            do{
                request.httpBody = try JSONEncoder().encode(model)
            }
            catch{
                print(error)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(Result.error(description: error.localizedDescription))
            }
            if
                let data = data {
                do {
                    let result = try JSONDecoder().decode(parseType, from: data)
                    // возврат
                    completion(Result.some(object: result))
                } catch {
                    print(error)
                    completion(Result.error(description: error.localizedDescription))
                }
            } else {
                completion(Result.error(description: "C сервера не пришли данные"))
            }
        }
        task.resume()
    }
}
