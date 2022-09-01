//
//  detailedViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

enum ConstantMessages: String {
    case nilImageButNoError = "Please try again in some time"
    case withError = "Please try again in some time.. we have encounterde : "
}

class DetailedViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var imageChangeObservation: NSKeyValueObservation?
    private var errorTask: DispatchWorkItem?
    
    
    
    //Model Interface variable
    private var detailedViewModel: DetailedViewModelInterface?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading(visbility: true)
        self.loadSelectedImage()
        self.setExplanation()
        self.addObserverForImageView()
        self.addGesturesForView()
    }
    
    deinit {
        imageChangeObservation = nil
    }
}



//MARK: - Initialising model interface
extension DetailedViewController {
    
    func intialiseModel() {
        self.detailedViewModel = DetailedViewModel()
    }
    
    func fetchModelData(model: [GalleryModel], index: Int) {
        self.detailedViewModel?.NasaGalaryData = model
        self.detailedViewModel?.indexOfObject = index
    }
    
}


//MARK: - setting data to DetailedViewController
extension DetailedViewController {
    private func setImageOnMainThread(image:UIImage) {
         DispatchQueue.main.async {[weak self] in
             self?.fullScreenImage.image = image
         }
     }
     
     private func setExplanation() {
         DispatchQueue.main.async {[weak self] in
             self?.textView.text = self?.detailedViewModel?.getImageExplanation()
         }
        
     }
}




//MARK: - Logic related to next, previous and current image loading
extension DetailedViewController {
    
   private func loadSelectedImage() {
        self.detailedViewModel?.loadFullImage {[weak self] image, error in
            self?.dataCheker(image: image, error: error)
        }
    }
    
    
   private func fetchNext() {
        self.checkIfLastImageForLayout()
       
        self.detailedViewModel?.fetchNextImage{[weak self] image, error in
            self?.dataCheker(image: image, error: error)
        }
    }
    
    
   private func fetchPrevious() {
        self.checkIfLastImageForLayout()
       
        self.detailedViewModel?.fetchPrevious{[weak self] image, error in
            self?.dataCheker(image: image, error: error)
        }
    }
    
    
    func checkIfLastImageForLayout() {
        if self.detailedViewModel!.isLastImage() != true {
            self.showLoading(visbility: true)
            DispatchQueue.main.async {[weak self] in
                self?.fullScreenImage.image = nil
            }
        }
        self.setExplanation()
    }
    
    
    func dataCheker(image: UIImage?, error: Error?) {
        if error != nil && image == nil {
            errorTask?.cancel()
            if error?.localizedDescription != "cancelled" {
                showErrorAlert(with: true, errorDetails: error!.localizedDescription)
            }
        } else if image == nil && error == nil  {
            errorTask?.cancel()
            showErrorAlert(with: false)
        } else {
            self.setImageOnMainThread(image: image!)
        }
    }
    
    
    private func showErrorAlert(with error: Bool, errorDetails: String = "") {
        
        if error {
            errorTask = DispatchWorkItem {
                self.presentAlert(ConstantMessages.withError.rawValue + "\(errorDetails)") {[weak self] action in
                    self?.loadSelectedImage()
                }
            }
            
        } else {
            errorTask = DispatchWorkItem {
                self.presentAlert(ConstantMessages.nilImageButNoError.rawValue) {[weak self] action in
                    self?.loadSelectedImage()
                }
            }
        }
        
        DispatchQueue.global(qos: .background).async(execute: errorTask!)
        
    }
    
    
   
}


//MARK: - IBAction functions
extension DetailedViewController {
    
    @IBAction func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension DetailedViewController {
    func addObserverForImageView() {
        imageChangeObservation = fullScreenImage.observe(\.image, options: [.new]) { [weak self] (object, change) in
            if object.image != nil {
                self?.showLoading(visbility: false)
            }
        }
    }
    
    func addGesturesForView() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    
    @objc func handleLeftSwipe() {
        self.animateLeftSwipe()
        self.fetchNext()
        
    }
    
    @objc func handleRightSwipe() {
        self.animateRightSwipe()
        self.fetchPrevious()
    }
    
    func showLoading(visbility: Bool) {
        DispatchQueue.main.async {
            if visbility {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    func animateLeftSwipe() {
        self.fullScreenImage.fadeIn()
    }
    
    func animateRightSwipe() {
        self.fullScreenImage.fadeIn()
    }
}
