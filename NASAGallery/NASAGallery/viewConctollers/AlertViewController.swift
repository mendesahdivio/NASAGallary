//
//  AlertViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 01/09/22.
//

import Foundation
import UIKit
extension UIViewController {
    func presentAlert(_ message: String, completion: @escaping((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: completion))
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
        
    }
}
