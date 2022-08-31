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
    func returnCountOfImages() -> Int
}



class HomeViewModel: ModelInterface {
 
    var nasaGalleryData = [GalleryModel]()
    var urlImageLoader: UrlImageDataLoader?
    var cacheThumbnails = [IndexPath: UIImage]()
    
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
    
    func returnCountOfImages() -> Int {
        return nasaGalleryData.count
    }
    
    //MARK: returns thumbanils when requested in uicollectionview
    func getThumbnails(fromCollection indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        let index = indexPath.item
        if index < nasaGalleryData.count {
            
            if let cachedImage = cacheThumbnails[indexPath] {
                completion(cachedImage)
            } else {
                let urlForThumbnail = nasaGalleryData[index].url?.returnURl()
                urlImageLoader?.startLoadingImage(url: urlForThumbnail) {[weak self] data in
                    guard let data = data as? Data else {
                        //write code to handel other issues
                        return
                    }
                    let image = data.makeThumbnail()
                    self?.cacheThumbnails[indexPath] = image
                    completion(image)
                }
            }
        }
    }
    
    //MARK: returns full Sized Image on selection of the image
    func loadFullImage(fromCollection indexPath: IndexPath, completion: @escaping (UIImage) -> Void) {
        
    }
}
