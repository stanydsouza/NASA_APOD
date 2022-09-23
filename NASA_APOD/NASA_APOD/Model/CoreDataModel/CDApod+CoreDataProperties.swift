//
//  CDApod+CoreDataProperties.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 23/09/22.
//
//

import Foundation
import CoreData


extension CDApod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDApod> {
        return NSFetchRequest<CDApod>(entityName: "CDApod")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var favourite: Bool
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    
    
    func convertToAPOD() -> APODModel {
        return APODModel(date: date, explanation: explanation, media_type: type, thumbnail_url: thumbnail, title: title, url: url, favourite: favourite)
    }

}

extension CDApod : Identifiable {

}
