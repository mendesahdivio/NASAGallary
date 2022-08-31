//
//  ShadowForView.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    func makeViewCornersRounder(){
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = true;
    }
}
