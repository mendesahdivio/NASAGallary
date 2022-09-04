//
//  DetailedViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import Foundation
import UIKit

class DetailedViewController: UIViewController {
    
    //MARK: Metadeta related IBOutlets
    @IBOutlet weak var textViewHolderView: UIView!
    @IBOutlet weak var changeTextViewHolderBtn: UIButton!
    @IBOutlet weak var metaDataTextField: UITextView!
    @IBOutlet weak var textViewHolderHeigthConst: NSLayoutConstraint!
    
    //MARK: Detailled view Scrollview to embedd ImageView
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: embedded imageview in Scrollview
    @IBOutlet weak var fullScreenImage: UIImageView!
 
    //MARK: task item to prevent multiple calls to alertview
    private var errorTask: DispatchWorkItem?
    
    //MARK: flag to check if metaData view is showing
    private var isShowingMetaDeta: Bool = false
    
    
    
    
    //Model Interface variable
    private var detailedViewModel: DetailedViewModelInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSelectedImage()
        self.addGesturesForView()
        self.addGestureForDoubleClick()
        self.setMinAndMaxZoomScale()
        self.setTextViewText()
       
    }
    
    
}





//MARK: - Initialising model interface
extension DetailedViewController {
    
    //MARK: intialises detailedViewModel instantiation of view
    func intialiseModel() {
        self.detailedViewModel = DetailedViewModel()
    }
    
    //MARK: sets data to detailedViewModel during instantiation of view
    func fetchModelData(model: [GalleryModel], index: Int) {
        self.detailedViewModel?.NasaGalaryData = model
        self.detailedViewModel?.indexOfObject = index
    }
    
}


//MARK: - setting data to DetailedViewController
extension DetailedViewController {
    
    //MARK: sets fullScreen Image
    private func setImageOnMainThread(image:UIImage) {
        DispatchQueue.main.async {[weak self] in
            self?.fullScreenImage.image = image
        }
    }
    
}





//MARK: - Logic related to next, previous and current image loading
extension DetailedViewController {
    
    
    //MARK: Querries detailedViewModel return the selected image from the collectionView
    private func loadSelectedImage() {
        self.detailedViewModel?.loadFullImage(imageView: self.fullScreenImage) {[weak self] error in
            self?.dataChecker(error: error)
        }
    }
    
    
    //MARK: Querries detailedViewModel return the Next image from modelData on user next swipe
    private func fetchNext() {
        self.detailedViewModel?.fetchNextImage{[weak self] error in
            self?.dataChecker(error: error)
        }
        setTextViewText()
    }
    
    
    //MARK: Querries detailedViewModel return the Previous image from modelData on user Previous swipe
    private func fetchPrevious() {
        self.detailedViewModel?.fetchPrevious{[weak self]  error in
            self?.dataChecker(error: error)
        }
        setTextViewText()
    }
    
    
    //MARK: checks whether the image swipped by the user is the last available image
    func checkIfLastImageForLayout() -> Bool {
        if self.detailedViewModel!.isLastImage() != true {
            return false
        }
        return true
    }
    
    
   
}





//MARK: - Logic related to showing error if there is an error recived from the model to the controller
extension DetailedViewController {
    
    //MARK: checks the data returned from the callback if error then triggers alertview
    func dataChecker(error: Error?) {
        errorTask?.cancel()
        if error != nil {
            showErrorAlert(with: true, errorDetails: error!.localizedDescription)
        }
    }
    
    
    //MARK: Shoes error alert if error is not nil
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
    
    //MARK: dismisses the view when clicked on back buttom
    @IBAction func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: shows meta Data view on click of the more button
    @IBAction func ShowMetaData(_ button: UIButton) {
        DispatchQueue.main.async {[weak self] in
            let isShowing = self?.isShowingMetaDeta
            self?.changeSizeOfView(revertOriginal: isShowing!)
            self?.changeTextOfButton(changeTitle: isShowing!)
        }
        
    }
}





//MARK: - scrollview delegates and scales
extension DetailedViewController: UIScrollViewDelegate {
    
    //MARK: Sets Minimum and Maximum size of zoom scale for scrollview
    func setMinAndMaxZoomScale() {
        let minScale = scrollView.frame.size.width / fullScreenImage.frame.size.width;
        scrollView.minimumZoomScale = minScale;
        scrollView.maximumZoomScale = 2.0;
        scrollView.contentSize = fullScreenImage.frame.size;
        scrollView.delegate = self;
    }
    
    //MARK: Sets Delegate viewForZooming as FullScreenImageView
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImage
    }
}





//MARK: -  all gesture related code for scroll view and the swiping
extension DetailedViewController {
    
    //MARK: Adds double tap gesture to the View
    func addGestureForDoubleClick() {
        let tap =  UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
    }
    
    
    //MARK: Adds leftSwipe and rightSwipe Gestures to the View
    func addGesturesForView() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    
    //MARK: handles the double tap gesture
    @objc func doubleTap() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    
    //MARK: Handles LeftSwipe gesture on the view
    @objc func handleLeftSwipe() {
        self.animateLeftSwipe()
        self.fetchNext()
        
    }
    
    
    //MARK: Handles RightSwipe gesture on the view
    @objc func handleRightSwipe() {
        self.animateRightSwipe()
        self.fetchPrevious()
    }
    
  
    //MARK: Adds animation for left swipe to imageview
    func animateLeftSwipe() {
        if  !self.checkIfLastImageForLayout() {
            self.fullScreenImage.slideInFromLeft()
        }
        
    }
    
    //MARK: Adds animation for right swipe to imageview
    func animateRightSwipe() {
        if !self.checkIfLastImageForLayout() {
            self.fullScreenImage.slideInFromRight()
        }
        
    }
}





//MARK: - UIConfiguration for metaData related UI
extension DetailedViewController {
    
    //MARK: Sets TextView data From detailedViewModel
    func setTextViewText() {
        metaDataTextField.text = detailedViewModel?.makeTextForTextView(title: "Title: ")
        self.changeTextViewHolderBtn.isHidden = false
    }
    
    
    //MARK: changes button title on selection
    func changeTextOfButton(changeTitle isMore: Bool) {
        //FIXME: value of the boolean doesnt get updated fast enoguh so written opposite logic here
        if isMore {
            changeTextViewHolderBtn.isSelected = false
            changeTextViewHolderBtn.setTitle(more, for: .normal)
            
            
        } else {
            changeTextViewHolderBtn.isSelected = true
            changeTextViewHolderBtn.setTitle(less, for: .selected)
        }
        
        
    }
    
    
    //MARK: changes the size of the view 
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


