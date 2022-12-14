//
//  DetailedViewModel.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

//MARK: - DetailedViewModelInterface
protocol DetailedViewModelInterface {
    func fetchNextImage(completion: @escaping (Error?) -> Void)
    func fetchPrevious(completion: @escaping (Error?) -> Void)
    func loadFullImage(imageView: UIImageView, completion: @escaping (Error?) -> Void) 
    func isLastImage() -> Bool
    func getImageTitle() -> String
    func makeTextForTextView(title: String) -> String
    var NasaGalaryData: [GalleryModel] {get set}
    var indexOfObject: Int {get set}
}




class DetailedViewModel: DetailedViewModelInterface {
    
    //MARK: stores index of object selecte
    private var index: Int = 0
    
    private var nukeImageLoader: NukeImageLoader?
    
    private var nasaGalleryData = [GalleryModel]()
    
    fileprivate var imageView: UIImageView?
    
    //MARK: stores image cache
    private var cache: NSCache<NSNumber, UIImage> = NSCache<NSNumber, UIImage>()
   
    //MARK: Used for UnitTest Only has dependency
    var testImageView: UIImageView {
        get {
            return imageView ?? UIImageView()
        }
        set(val) {
            self.imageView = val
        }
    }
    
    
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
        nukeImageLoader = NukeImageLoader()
        cache.totalCostLimit = 50_000_000
    }
    
    //MARK: fetches next gallery image
    func fetchNextImage(completion: @escaping (Error?) -> Void) {
        let count = nasaGalleryData.count
        let currentIndex = index
        if currentIndex + 1 < count {
            index = currentIndex + 1
            self.loadFullImage(imageView: self.imageView!, completion: completion)
        }
    }
    
    //MARK: fetches previous gallery image
    func fetchPrevious(completion: @escaping (Error?) -> Void) {
        let currentIndex = index
        if currentIndex - 1 >= 0 {
            index = currentIndex - 1
            self.loadFullImage(imageView: self.imageView!, completion: completion)
        }
    }
    
    //MARK: checks if last image in model data array and returns flag for the same
    func isLastImage() -> Bool {
        if index == 0 || index == nasaGalleryData.count - 1{
            return true
        }
        
        return false
    }
    
    //MARK: gets model explanation for image
    func getImageExplanation() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].explanation ?? ""
        }
        
        return ""
    }
    
    //MARK: gets Title for image
    func getImageTitle() -> String {
        if index < nasaGalleryData.count {
            return nasaGalleryData[index].title ?? ""
        }
        
        return ""
    }
    
    //MARK: gets Date for image
    func getDate() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].date ?? ""
        }
        
        return ""
    }
    
    //MARK: gets getCopyRight for image
    func getCopyRight() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].copyright ?? ""
        }
        return ""
    }
    
    //MARK: gets HdUrl for image
    func getHdUrl() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].hdurl ?? ""
        }
        return ""
    }
    
    //MARK: gets Url for image
    func getUrl() -> String {
        if isIndexWithinBounds() {
            return nasaGalleryData[index].url ?? ""
        }
        return ""
    }
    
   //MARK: checks if class index value is within bounds of model data array
   func isIndexWithinBounds() -> Bool {
        if index < nasaGalleryData.count {
            return true
        }
        return false
    }
    
}

//MARK: - this extension defines a func to load full image by querring nukeImageLoader for full image and returns error if occured
extension DetailedViewModel {
    
    //MARK: func to load full image by querring nukeImageLoader for full image and returns error if occured
    func loadFullImage(imageView: UIImageView, completion: @escaping (Error?) -> Void) {
        self.imageView = imageView
        if isIndexWithinBounds() {
            nukeImageLoader?.stopPreviousRequesIfViewChanged()
            let indexNumer = NSNumber(value: index)
            if let cachedImage = cache.object(forKey: indexNumer) {
                imageView.image = cachedImage
            } else {
                imageView.image = nukeImageLoader?.makeGif()
                let urlForThumbnail = nasaGalleryData[index].hdurl?.returnURl()
                nukeImageLoader?.loadFullImage(imageView: imageView, url: urlForThumbnail!) {[weak self] error, image  in
                    if let image = image {
                        self?.cache.setObject(image, forKey: indexNumer)
                    }
                    completion(error)
                }
            }
            
        }
    }
    
}


//MARK: - this extension defines a func to generate a string from all metadata
extension DetailedViewModel {
    
    //MARK: a func to generate a string from all metadata
    func makeTextForTextView(title:String = "") -> String {
        let text:String = "\(title) \(getImageTitle())\n\nCOPY RIGHT:  \(getCopyRight())\n\nURL:  \(getHdUrl())\n\nHDURL:  \(getHdUrl())\n\nDATE: \(getDate())\n\nINFO: \(getImageExplanation())"
        return text
    }
    
}

