//
//  HomeViewModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

protocol ModelInterface {
    func getThumbnails(fromCollection indexPath: IndexPath, completion: @escaping (UIImage) -> Void)
    func loadFullImage(fromCollection indexPath: IndexPath, completion: @escaping (UIImage) -> Void)
}



class HomeViewModel: ModelInterface {
 
    var nasaGalleryData = [GalleryModel]()
    var urlImageLoader: UrlImageDataLoader?
    
    init() {
        setModel()
        urlImageLoader = UrlImageDataLoader()
    }
    
    func setModel() {
        do {
            let gallery = try JSONDecoder().decodeNASAGalaryData()
            nasaGalleryData = gallery!
        } catch {
            debugPrint("the json decoder returned nil : \(error.localizedDescription)")
        }
    }
    
    //MARK: returns thumbanils when requested in uicollectionview
    func getThumbnails(fromCollection indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        let index = indexPath.item
        if index < nasaGalleryData.count {
            let urlForThumbnail = nasaGalleryData[index].url?.returnURl()
            urlImageLoader?.startLoadingImage(url: urlForThumbnail) { data in
                if let  data = data, ((data as? Data) != nil) {
                    
                }
            }
        }
    }
    
    //MARK: returns full Sized Image on selection of the image
    func loadFullImage(fromCollection indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        
    }
}
