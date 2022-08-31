//
//  CommonCodeViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

extension UINavigationController {
    func instiateViewController(vc: UIViewController) {
        self.pushViewController(vc, animated: true)
    }
}


extension UIStoryboard {
    func instiateVC(viewcControllerID: String) -> UIViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: viewcControllerID)
        return vc
    }
}
