//
//  Services.swift
//  Betane Test
//
//  Created by Robert Ferreira on 29/11/2022.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}


class Services {
   
    static func getData(url: String, completion: @escaping (Result<Data>) -> Void) {
        let url = URL(string: url)!

        URLSession.shared.dataTask(with: url, completionHandler: { (data,response,error) -> Void in
            guard let data = data else {
                completion(.error("No data"))
                return
            }

            completion(.success(data))
            
        }).resume()

    }
    
    static func getSports(completion: @escaping (Result<[Sport]>) -> Void) {
       let url = "https://618d3aa7fe09aa001744060a.mockapi.io/api/sports"
        getData(url: url, completion: { result in
            switch result {
            case let .success(data):
                //encode data
                do {

                    let sports = try JSONDecoder().decode([Sport].self, from: data)

                    completion(.success(sports))

                } catch let jsonErr {
                    completion(.error(jsonErr.localizedDescription))
                }
            default: completion(.error("No data"))
            }
        })
    }
    
}
