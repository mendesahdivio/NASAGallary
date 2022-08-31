//
//  GallareyModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
struct GalleryModel: Decodable, Identifiable {
    
    var id =  UUID()
    
    var copyright: String?
    
    var date: String?
    
    var explanation: String?
    
    var hdurl: String?
    
    var media_type: String?
    
    var title: String?
    
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl, media_type, title, url
    }
}
