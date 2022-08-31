//
//  ImageGenerator.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation


class  UrlImageDataLoader {
   
    fileprivate var urlSession = URLSession.shared
    var task: URLSessionDataTask?
   
    
    func startLoadingImage(url: URL?, completion:@escaping (Any?) ->  Void) {
        guard  let url = url else {
            completion(nil)
            return
        }
        task = urlSession.dataTask(with: url) {[weak self] (data, response, error) in
            if response == nil || data == nil {
                self?.task?.cancel()
                completion(error)
                
            } else {
                completion(data)
            }
        }
        task?.resume()
    }
}




