//
//  APODModel.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 22/09/22.
//

import Foundation

struct APODModel : Decodable {
    
    let date : String?
    let explanation : String?
    let media_type : String?
    let thumbnail_url : String?
    let title : String?
    let url : String?
    var favourite = false

    enum CodingKeys: String, CodingKey {

        case date = "date"
        case explanation = "explanation"
        case media_type = "media_type"
        case thumbnail_url = "thumbnail_url"
        case title = "title"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        explanation = try values.decodeIfPresent(String.self, forKey: .explanation)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
        thumbnail_url = try values.decodeIfPresent(String.self, forKey: .thumbnail_url)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
    init(date: String?, explanation: String?, media_type: String?, thumbnail_url: String?, title: String?, url: String?, favourite: Bool) {
        self.date = date
        self.explanation = explanation
        self.media_type = media_type
        self.thumbnail_url = thumbnail_url
        self.title = title
        self.url = url
        self.favourite = favourite
    }

}

