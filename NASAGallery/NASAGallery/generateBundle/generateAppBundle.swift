//
//  generateAppBundle.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 03/09/22.
//

import Foundation
extension Bundle {
    func loadBundle() -> Bundle {
        return Bundle(for: type(of: self))
    }
}
