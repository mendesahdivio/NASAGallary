//
//  CommonCodeViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

//MARK: storyborad instantiation for view controller file
extension UIStoryboard {
    func instiateVC(viewcControllerID: String) -> UIViewController {
        let vc = UIStoryboard.init(name: storyBoardName, bundle: Bundle.main).instantiateViewController(withIdentifier: viewcControllerID)
        return vc
    }
}
