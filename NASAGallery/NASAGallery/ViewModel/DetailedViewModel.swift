//
//  DetailedViewModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

protocol DetailedViewModelInterface {
    func loadFullImage(completion: @escaping (UIImage?) -> Void)
    func fetchNextImage(completion: @escaping (UIImage?) -> Void)
    func fetchPrevious(completion: @escaping (UIImage?) -> Void)
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
    }
    
   
    //MARK: returns full Sized Image on selection of the image
    func loadFullImage( completion: @escaping (UIImage?) -> Void) {
        if isIndexWithinBounds() {
            if let cachedImage = cachedData[index] {
                completion(cachedImage)
            } else {
                let urlForThumbnail = nasaGalleryData[index].hdurl?.returnURl()
                urlImageLoader?.startLoadingImage(url: urlForThumbnail, taskType: .FullImage) {[weak self] data in
                    guard let data = data as? Data else {
                        //write code to handel other issues
                        return
                    }
                    guard let image = UIImage(data: data) else{
                        completion(nil)
                        return
                    }
                    let index = self?.index
                    self?.cachedData[index!] = image
                    completion(image)
                }
            }
        }
    }
    
    
    func fetchNextImage(completion: @escaping (UIImage?) -> Void) {
        let count = nasaGalleryData.count
        let currentIndex = index
        if currentIndex + 1 < count {
            index = currentIndex + 1
            self.loadFullImage(completion: completion)
        }
    }
    
    
    func fetchPrevious(completion: @escaping (UIImage?) -> Void) {
        let currentIndex = index
        if currentIndex - 1 > 0 {
            index = currentIndex - 1
            self.loadFullImage(completion: completion)
        }
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
