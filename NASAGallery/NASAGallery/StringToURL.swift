//
//  StringToURL.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation

extension String {
    func returnURl() -> URL? {
        if let url = URL(string: self) {
            return url
        } else {
            return nil
        }
    }
}
