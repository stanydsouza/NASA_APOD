//
//  APIService.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 22/09/22.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown
    case apiError(reason: String)
    case jsonDecoding
    case noData
    case nonSuccessStatusCode
    case serverError
    case urlError
    case noResponse
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .jsonDecoding:
            return "Json decoding error"
        case .noData:
            return "No data found"
        case .nonSuccessStatusCode:
            return "No success response"
        case .serverError:
            return "Inavlid response form server"
        case .urlError:
            return "Inavlid url"
        case .noResponse:
            return "No response from server"
        case .apiError(let reason):
            return reason
        }
    }
}

final class APIService {
    
    static let shared: APIService = APIService()
    
    private init(){
        
    }
    
    func callRequest(_ request: URLRequest, completion: @escaping (Result<Data,APIError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.apiError(reason: error.localizedDescription)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            guard let data = data, response.statusCode >= 200 && response.statusCode <= 299 else {
                completion(.failure(.nonSuccessStatusCode))
                return
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
        
    }
    
    func getRequest(_ url: URL, completion: @escaping (Result<Data,APIError>) -> Void){
        
        let request = URLRequest(url: url)
        callRequest(request, completion: completion)
            
    }
    
    func getRequest<T: Decodable>(_ url: URL, resultType: T.Type, completion: @escaping (Result<T,APIError>) -> Void){
        getRequest(url) { result in
            
            switch result {
                
            case .success(let data):
                do {
                    let resp = try JSONDecoder().decode(resultType, from: data)
                    completion(.success(resp))
                }
                catch {
                    completion(.failure(.jsonDecoding))
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
            
        }
    }
    
}
