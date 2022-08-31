//
//  UICollectionViewCell.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

class GalleryCelll: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func addShadow() {
        self.shadowView.makeViewCornersRounder()
        self.imageView.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
    }
}
