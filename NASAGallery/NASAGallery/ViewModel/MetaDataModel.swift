//
//  MetaDataModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation

struct MetaDataModel {
    var copyright: String?
    
    var date: String?
    
    var explanation: String?
    
    var media_type: String?
    
    var title: String?
    
    init(copyRight: String, date: String, explanation: String, media_type: String, title: String) {
        self.copyright = copyRight
        self.date = date
        self.explanation = explanation
        self.media_type = media_type
        self.title = title
    }
}
