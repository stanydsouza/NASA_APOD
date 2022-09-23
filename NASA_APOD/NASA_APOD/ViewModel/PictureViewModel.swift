//
//  PictureViewModel.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 22/09/22.
//

import Foundation

final class PictureViewModel {
    
    private let dataRepository: PictureDataRepository
    
    init(dataRepository: PictureDataRepository) {
        self.dataRepository = dataRepository
    }
    
    func getDetails(date: Date, completion: @escaping (Result<APODModel,APIError>) -> Void){
        
        let dateStr = date.toString(format: "yyyy-MM-dd")
        
        if let model = dataRepository.getData(dateStr){
            completion(.success(model))
        }
        else{
            getFromAPI(date: dateStr, completion: completion)
        }
        
        
    }
    
    private func getFromAPI(date: String, completion: @escaping (Result<APODModel,APIError>) -> Void){
        APODService().getPictureDetails(date: date) { [weak self] result in
            switch result {
                
            case .success(let data):
                self?.dataRepository.saveData(data)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                break
            }
        }
    }
    
    func updateFavourite(_ model: APODModel){
        dataRepository.updateData(model)
    }
    
}
