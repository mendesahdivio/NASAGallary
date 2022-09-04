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

enum TaskType {
    case Thumbnail
    case FullImage
}


class  NukeImageLoader {
    fileprivate var itemGeneratorTask:DispatchWorkItem!
}




//Uses Nuke extension for UiCollectionView
extension NukeImageLoader {
    @MainActor func loadImageCell(url: URL, imageView: UIImageView, cellSize: CGFloat) {
        NukeExtensions.loadImage(with: createImageRequest(url: url, cellSize: cellSize), options: makeImageLoadingOptions(), into: imageView)
    }
    
    
    func makeImageLoadingOptions() -> ImageLoadingOptions {
        return ImageLoadingOptions(placeholder: makeErrorAndHolderImage(name: "cellHolderIcons"), transition: .fadeIn(duration: 0.5), failureImage: makeErrorAndHolderImage(name: "failerImageSet"))
    }
    
    
    func makeErrorAndHolderImage(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: type(of: self)), compatibleWith: nil)
    }
    
    func createImageRequest(url: URL, cellSize size: CGFloat) -> ImageRequest {
        let imageRequest = ImageRequest(url: url, processors: generateImageProcessor(imageViewSize: size))
        return imageRequest
    }
    
    func generateImageProcessor(imageViewSize: CGFloat) -> [ImageProcessing] {
        let pixelSize = imageViewSize * UIScreen.main.scale
        let imageSize = CGSize(width: pixelSize, height: pixelSize)
        let imageProcessing = [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
        return imageProcessing
    }
}


//Nuke for full image loading
extension NukeImageLoader {
    func loadFullImage(imageView: UIImageView, url: URL, completion: @escaping(Error?, UIImage?) -> Void) {
      
        itemGeneratorTask = DispatchWorkItem {
            ImagePipeline.shared.loadImage(
              with: url) {[weak self] response in
            
              // 5
              switch response {
              // 6
              case .failure:
                  imageView.image = self?.makeErrorAndHolderImage(name: "failerImageSet")
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
    
    
    //Prevents data inconsitancy
    func stopPreviousRequesIfViewChanged() {
        if itemGeneratorTask != nil {
            itemGeneratorTask.cancel()
        }
    }
    
    func makeGif() -> UIImage? {
        let gif = UIImage.gifImageWithName("2QrM")
        return gif
    }
}








