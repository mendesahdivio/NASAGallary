//
//  DetailedInfoViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 03/09/22.
//

import Foundation
import UIKit

class DetailedInfoViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var HdUrlLabel: UILabel!
    
   private var detailedInfoModel: DetailedInfoProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUiData()
    }
    
    
    func initaliseModel(title:String, copyRight:String, HDUrl:String, url:String, description: String) {
        self.detailedInfoModel = DetailedInfoModel()
        self.detailedInfoModel?.store(title: title, copyRight: copyRight, url: HDUrl, hdUrl: url, discription: description)
    }
    
}

extension DetailedInfoViewController {
    func setUiData() {
        self.textView.text = self.detailedInfoModel?.description
        self.titleLabel.text = self.detailedInfoModel?.title
        self.copyRightLabel.text = self.detailedInfoModel?.compyRight
        self.urlLabel.text = self.detailedInfoModel?.url
        self.HdUrlLabel.text = self.detailedInfoModel?.hdUrl
    }
}



