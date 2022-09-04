//
//  NukeImageLoader.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import NukeExtensions
import Nuke
import UIKit
import NukeUI

//MARK: - this class handels loading of images asyncronusly in them image view by using NukeExtension, NukeUI, and Nuke from Nuke Library
class  NukeImageLoader {
    fileprivate var itemGeneratorTask:DispatchWorkItem!
}


//MARK: Uses Nuke extension for UiCollectionView
extension NukeImageLoader {
    
    //MARK: Loads image in cell
    @MainActor func loadImageCell(url: URL, imageView: UIImageView, cellSize: CGFloat) {
        NukeExtensions.loadImage(with: createImageRequest(url: url, cellSize: cellSize), options: makeImageLoadingOptions(), into: imageView)
    }
    
    //MARK: creates ImageLoadingOptions to handle cases of place holder image and failure image
    func makeImageLoadingOptions() -> ImageLoadingOptions {
        return ImageLoadingOptions(placeholder: makeErrorAndHolderImage(name: cellHolderImageName), transition: .fadeIn(duration: 0.5), failureImage: makeErrorAndHolderImage(name: failureImageName))
    }
    
    //MARK: makes place holder and errorImage
    func makeErrorAndHolderImage(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
    
    //MARK: creates ImageRequest object for NUKE to load images according to cell size to prevent memory over use
    func createImageRequest(url: URL, cellSize size: CGFloat) -> ImageRequest {
        let imageRequest = ImageRequest(url: url, processors: generateImageProcessor(imageViewSize: size))
        return imageRequest
    }
    
    //MARK: generates [ImageProcessing] array for ImageRequest
    func generateImageProcessor(imageViewSize: CGFloat) -> [ImageProcessing] {
        let pixelSize = imageViewSize * UIScreen.main.scale
        let imageSize = CGSize(width: pixelSize, height: pixelSize)
        let imageProcessing = [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
        return imageProcessing
    }
}


//MARK: Nuke for full image loading
extension NukeImageLoader {
    
    //MARK: loads full image for detailed view model
    func loadFullImage(imageView: UIImageView, url: URL, completion: @escaping(Error?, UIImage?) -> Void) {
      
        itemGeneratorTask = DispatchWorkItem {
            ImagePipeline.shared.loadImage(
              with: url) {[weak self] response in
              switch response {
            
              case .failure:
                  imageView.image = self?.makeErrorAndHolderImage(name: failureImageName)
                  imageView.contentMode = .scaleAspectFit
                  completion(ImagePipeline.Error.dataIsEmpty, nil)
              // 7
              case let .success(imageResponse):
                  imageView.image = imageResponse.image
                  imageView.contentMode = .scaleAspectFit
                  completion(nil, imageView.image)
              }
            }
        }
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: itemGeneratorTask)

    }
    
    
    //MARK: Prevents data inconsitancy
    func stopPreviousRequesIfViewChanged() {
        if itemGeneratorTask != nil {
            itemGeneratorTask.cancel()
        }
    }
    
    //MARK: creates gif for loading animation in detailledview controller imageView
    func makeGif() -> UIImage? {
        let gif = UIImage.gifImageWithName(gifImage)
        return gif
    }
}








