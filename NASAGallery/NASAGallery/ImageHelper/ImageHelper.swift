//
//  ImageHelper.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

extension Data {
    func makeThumbnail() -> UIImage {
        guard let uiImage = UIImage(data: self)?.preparingThumbnail(of: CGSize(width: 200, height: 200)) else{
            //set some default image
            return UIImage()
        }
        return uiImage
    }
}
