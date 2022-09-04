//
//  DetailedInfoModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 03/09/22.
//

import Foundation

protocol DetailedInfoProtocol {
    var title: String? {get set}
    var compyRight: String? {get set}
    var url:String? {get set}
    var hdUrl:String? {get set}
    var description: String? {get set}
    mutating func store(title: String, copyRight: String, url: String, hdUrl: String, discription: String)
}


struct DetailedInfoModel: DetailedInfoProtocol {
    
    var title: String?
    
    var compyRight: String?
    
    var url: String?
    
    var hdUrl: String?
    
    var description: String?
    
    
    mutating func store(title: String, copyRight: String, url: String, hdUrl: String, discription description: String) {
        self.title = title
        self.compyRight = copyRight
        self.url = url
        self.hdUrl = hdUrl
        self.description = description
    }
    
}
