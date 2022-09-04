//
//  HomeViewModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit


protocol HomeViewModelInterface {
    func getThumbanilUsingNuke(formCollection indexPath: IndexPath, ImageView: UIImageView?, cellSize: CGFloat)
    func returnCountOfImages() -> Int
    var getModelData: [GalleryModel] {get}
}



class HomeViewModel: HomeViewModelInterface {
    var nasaGalleryData = [GalleryModel]()
    var nukeImageLoader: NukeImageLoader?
    var cache = NSCache<NSNumber, UIImage>()
    
    init() {
        setModel()
        nukeImageLoader = NukeImageLoader()
    }
    
    var getModelData: [GalleryModel] {
        get {
            return nasaGalleryData
        }
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
        
    func getThumbanilUsingNuke(formCollection indexPath: IndexPath, ImageView cellImageView: UIImageView?, cellSize: CGFloat)   {
        let index = indexPath.item
        if index < nasaGalleryData.count {
            let numberIndex = NSNumber(value: index)
            if let cachedImage = cache.object(forKey: numberIndex) {
                cellImageView!.image = cachedImage
            } else {
                let urlForThumbnail = nasaGalleryData[index].url?.returnURl()
                DispatchQueue.main.async {[weak self] in
                    self?.nukeImageLoader?.loadImageCell(url: urlForThumbnail!, imageView: cellImageView!, cellSize: cellSize)
                }
            }
        }
    }
        
}
