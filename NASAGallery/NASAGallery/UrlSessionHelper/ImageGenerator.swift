//
//  ImageGenerator.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation

enum TaskType {
    case Thumbnail
    case FullImage
}


class  UrlImageDataLoader {
   
    fileprivate var urlSession = URLSession.shared
    var task: URLSessionDataTask?
   
    
    func startLoadingImage(url: URL?, taskType: TaskType = .Thumbnail, completion:@escaping (Any?) ->  Void) {
        guard  let url = url else {
            completion(nil)
            return
        }
        
        if taskType == .FullImage {
            task?.cancel()
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








