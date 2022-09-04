//
//  JSonDecoder.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation


//MARK: Class extension of JsonDecoder Decodes Json as array of GalleryModel
extension JSONDecoder {
    func decodeNASAGalaryData(resourceName: String = jsonFileName, fileExtension: String = "json") throws -> [GalleryModel]? {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: fileExtension), let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        
        do {
            let arryGallery = try decoder.decode([GalleryModel].self, from: data)
            return arryGallery
        } catch {
            throw error
        }
    }
}
