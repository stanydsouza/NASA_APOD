//
//  DataRepository.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 22/09/22.
//

import Foundation

protocol DataRepository {
    associatedtype Item
    
    func saveData(_ data: Item)
    func getData(_ date: String) -> Item?
    func updateData(_ model: Item)
}

final class PictureDataRepository: DataRepository {
    
    func saveData(_ data: APODModel){
        
        let object = CDApod(context: PersistentStorage.shared.context)
        object.date = data.date
        object.title = data.title
        object.url = data.url
        object.type = data.media_type
        object.thumbnail = data.thumbnail_url
        object.favourite = data.favourite
        object.explanation = data.explanation
        
        PersistentStorage.shared.saveContext()
    }
    
    func getData(_ date: String) -> APODModel?{
        
        let data = getCDApod(date)
        let model = data?.convertToAPOD()
        return model
        
    }
    
    private func getCDApod(_ date: String) -> CDApod? {
        let predicate: NSPredicate = .init(format: "date = %@", date)
        let arr = getDataFromPredicate(predicate)
        return arr.first
    }
    
    func getFavourites() -> [APODModel] {
        let predicate: NSPredicate = .init(format: "favourite = %d", true)
        let arr = getDataFromPredicate(predicate)
        let modelArr: [APODModel] = arr.map { $0.convertToAPOD() }
        return modelArr
    }
    
    private func getDataFromPredicate(_ predicate: NSPredicate) -> [CDApod]{
        let request = CDApod.fetchRequest()
        request.predicate = predicate
        
        do{
            let arr: [CDApod] = try PersistentStorage.shared.context.fetch(request)
            return arr
        }
        catch {
            return []
        }
        
    }
    
    func updateData(_ model: APODModel){
        let data = getCDApod(model.date!)
        data?.favourite = model.favourite
        
        PersistentStorage.shared.saveContext()
        
    }
    
}
