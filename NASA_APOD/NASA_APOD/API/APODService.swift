//
//  APODService.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 22/09/22.
//

import Foundation

final class APODService {
    
    func getPictureDetails(date: String, completion: @escaping (Result<APODModel,APIError>) -> Void){
        
        var urlComponents = URLComponents(string: Constants.apiUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.apiKey),
            URLQueryItem(name: "date", value: date),
            URLQueryItem(name: "thumbs", value: "true")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.urlError))
            return
        }
        
        APIService.shared.getRequest(url, resultType: APODModel.self, completion: completion)
            
    }
    
}



