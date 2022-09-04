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
    case withError = "Please try again in some time.."
}

class DetailedViewController: UIViewController {
    
    //Detailed MetaData of image
    @IBOutlet weak var textViewHolderView: UIView!
    @IBOutlet weak var changeTextViewHolderBtn: UIButton!
    @IBOutlet weak var metaDataTextField: UITextView!
    @IBOutlet weak var textViewHolderHeigthConst: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var errorTask: DispatchWorkItem?
    private var didAlreadyClicktabBar: Bool = false
    private var isShowingMetaDeta: Bool = false
    
    
    
    
    //Model Interface variable
    private var detailedViewModel: DetailedViewModelInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading(visbility: true)
        self.loadSelectedImage()
        self.addGesturesForView()
        self.addGestureForDoubleClick()
        self.setMinAndMaxZoomScale()
        self.setTextViewText()
       
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
}




//MARK: - Logic related to next, previous and current image loading
extension DetailedViewController {
    
    private func loadSelectedImage() {
        self.detailedViewModel?.loadFullImage(imageView: self.fullScreenImage) {[weak self] error in
            self?.dataChecker(error: error)
        }
    }
    
    
    private func fetchNext() {
        self.detailedViewModel?.fetchNextImage{[weak self] error in
            self?.dataChecker(error: error)
        }
        setTextViewText()
    }
    
    
    private func fetchPrevious() {
        self.detailedViewModel?.fetchPrevious{[weak self]  error in
            self?.dataChecker(error: error)
        }
        setTextViewText()
    }
    
    
    func checkIfLastImageForLayout() -> Bool {
        if self.detailedViewModel!.isLastImage() != true {
            
            self.showLoading(visbility: true)
            return false
        }
        
        return true
    }
    
    
    func dataChecker(error: Error?) {
        errorTask?.cancel()
        if error != nil {
            showErrorAlert(with: true, errorDetails: error!.localizedDescription)
        } else {
            showLoading(visbility: false)
        }
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
                self.presentAlert(ConstantMessages.withError.rawValue) {[weak self] action in
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
    
    
    @IBAction func ShowMetaData(_ button: UIButton) {
        DispatchQueue.main.async {[weak self] in
            let isShowing = self?.isShowingMetaDeta
            self?.changeSizeOfView(revertOriginal: isShowing!)
            self?.changeTextOfButton(changeTitle: isShowing!)
        }
        
    }
}


//MARK: - scrollview delegates and scales
extension DetailedViewController:UIScrollViewDelegate {
    func setMinAndMaxZoomScale() {
        let minScale = scrollView.frame.size.width / fullScreenImage.frame.size.width;
        scrollView.minimumZoomScale = minScale;
        scrollView.maximumZoomScale = 2.0;
        scrollView.contentSize = fullScreenImage.frame.size;
        scrollView.delegate = self;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImage
    }
}


//MARK: -  all gesture related code for scroll view and the swiping
extension DetailedViewController {
    func addGestureForDoubleClick() {
        let tap =  UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc func doubleTap() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
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
        if  !self.checkIfLastImageForLayout() {
            self.fullScreenImage.slideInFromLeft()
        }
        
    }
    
    func animateRightSwipe() {
        if !self.checkIfLastImageForLayout() {
            self.fullScreenImage.slideInFromRight()
        }
        
    }
}




//MARK: - UIConfiguration for metaData related UI
extension DetailedViewController {
    
    func setTextViewText() {
        metaDataTextField.text = detailedViewModel?.makeTextForTextView(title: "Title: ")
        self.changeTextViewHolderBtn.isHidden = false
    }
    
    
    func changeTextOfButton(changeTitle isMore: Bool) {
        //value of the boolean doesnt get updated fast enoguh so written opposite logic here
        if isMore {
            changeTextViewHolderBtn.isSelected = false
            changeTextViewHolderBtn.setTitle("MORE", for: .normal)
            
            
        } else {
            changeTextViewHolderBtn.isSelected = true
            changeTextViewHolderBtn.setTitle("LESS", for: .selected)
        }
        
        
    }
    
    
    func changeSizeOfView(revertOriginal sizeCheck: Bool) {
        if sizeCheck {
            textViewHolderHeigthConst.constant = 50
            textViewHolderView.needsUpdateConstraints()
            textViewHolderView.layoutIfNeeded()
            metaDataTextField.layoutIfNeeded()
            isShowingMetaDeta = false
        } else {
            textViewHolderHeigthConst.constant = 200
            textViewHolderView.needsUpdateConstraints()
            textViewHolderView.layoutIfNeeded()
            metaDataTextField.layoutIfNeeded()
            isShowingMetaDeta = true
        }
    }
}


