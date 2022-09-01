//
//  DetailedViewModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

protocol DetailedViewModelInterface {
    func loadFullImage(completion: @escaping (UIImage?, Error?) -> Void)
    func fetchNextImage(completion: @escaping (UIImage?, Error?) -> Void)
    func fetchPrevious(completion: @escaping (UIImage?, Error?) -> Void)
    func isLastImage() -> Bool
    func getImageExplanation() -> String
    func getImageTitle() -> String
    func getDate() -> String
    func getCopyRight() -> String
    var NasaGalaryData: [GalleryModel] {get set}
    var indexOfObject: Int {get set}
}




class DetailedViewModel: DetailedViewModelInterface {
    
    private var index: Int = 0
    private var urlImageLoader: UrlImageDataLoader?
    private var nasaGalleryData = [GalleryModel]()
    private var cachedData = [Int: UIImage]()
    private var cache: NSCache<NSNumber, UIImage> = NSCache<NSNumber, UIImage>()
    private var metaData: MetaDataModel?
    
    
    var NasaGalaryData: [GalleryModel] {
        get {
            return nasaGalleryData
        }
        set(value) {
            self.nasaGalleryData = value
        }
    }
    
    var indexOfObject: Int {
        get {
            return index
        }
        set(value) {
            self.index = value
        }
    }
    
    
    init() {
        urlImageLoader = UrlImageDataLoader()
        cache.totalCostLimit = 50_000_000
    }
    
   
    //MARK: returns full Sized Image on selection of the image
    func loadFullImage( completion: @escaping (UIImage?, Error?) -> Void) {
        if isIndexWithinBounds() {
            let indexNumer = NSNumber(value: index)
            if let cachedImage = cache.object(forKey: indexNumer) {
                completion(cachedImage, nil)
            } else {
                let urlForThumbnail = nasaGalleryData[index].hdurl?.returnURl()
                urlImageLoader?.startLoadingImage(url: urlForThumbnail, taskType: .FullImage) {[weak self] data in
                    guard let data = data as? Data else {
                        //write code to handel other issues
                        if let error = data as? Error {
                            completion(nil, error)
                        }
                        return
                    }
                    guard let image = UIImage(data: data) else{
                        completion(nil, nil)
                        return
                    }
                    self?.cache.setObject(image, forKey: indexNumer)
                    completion(image, nil)
                }
            }
        }
    }
    
    
    func fetchNextImage(completion: @escaping (UIImage?, Error?) -> Void) {
        let count = nasaGalleryData.count
        let currentIndex = index
        if currentIndex + 1 < count {
            index = currentIndex + 1
            self.loadFullImage(completion: completion)
        }
    }
    
    
    func fetchPrevious(completion: @escaping (UIImage?, Error?) -> Void) {
        let currentIndex = index
        if currentIndex - 1 >= 0 {
            index = currentIndex - 1
            self.loadFullImage(completion: completion)
        }
    }
    
    
    func isLastImage() -> Bool {
        if index == 0 || index == nasaGalleryData.count - 1{
            return true
        }
        
        return false
    }
    
    
    func getImageExplanation() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].explanation ?? ""
        }
        
        return ""
    }
    
    func getMetaData() -> MetaDataModel? {
        var metaData: MetaDataModel?
        if isIndexWithinBounds() {
            metaData = MetaDataModel(copyRight: nasaGalleryData[index].copyright ?? "", date: nasaGalleryData[index].date ?? "", explanation: nasaGalleryData[index].explanation ?? "", media_type: nasaGalleryData[index].media_type ?? "", title: nasaGalleryData[index].title ?? "")
        }
        return metaData
    }
    
    
    func getImageTitle() -> String {
        if index < nasaGalleryData.count {
            return nasaGalleryData[index].title ?? ""
        }
        
        return ""
    }
    
    
    func getDate() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].date ?? ""
        }
        
        return ""
    }
    
    
    func getCopyRight() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].copyright ?? ""
        }
        return ""
    }
    
    
   fileprivate func isIndexWithinBounds() -> Bool {
        if index < nasaGalleryData.count {
            return true
        }
        return false
    }
}
