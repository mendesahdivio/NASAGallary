//
//  Constants.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 04/09/22.
//

import Foundation
import UIKit

//MARK: error constants for Detailed view controller
enum ConstantMessages: String {
    case nilImageButNoError = "Please try again in some time"
    case withError = "Please try again in some time.."
}

//MARK: collection view cell name for GalleryCollectionView
let collectionViewCellName = "collectionViewCell"


//MARK: gifImageName
let gifImage = "2QrM"

//MARK: storyBoardName
let storyBoardName = "Main"


//MARK: Failure image
let failureImageName = "failerImageSet"


//MARK: CellHolderImage
let cellHolderImageName = "cellHolderIcons"


//MARK: jsonFileName
let jsonFileName = "NASAJsonFile"


//MARK: DetailledViewControllerID
let DetailedViewControllerID = "DetailedViewController"


//MARK: ButtonTiles
let less = "LESS"

let more = "MORE"

let Ok = "OK"

let Retry = "Retry"




//MARK: typealias for collectionView Delegates
typealias collectionViewSource = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout


//MARK: getsConstant Cell size
func generateCGFSize() -> CGFloat{
    let size = CGSize(width: 128.0, height: 128.0)
    let CGF = size.height * size.width
    return CGF
}



//MARK: testing Constants
enum testUrl: String{
    case normalUrl = "https://apod.nasa.gov/apod/image/1912/NGC6744_FinalLiuYuhang1024.jpg"
    case secondNonfake = "https://apod.nasa.gov/apod/image/1912/M27_Mazlin_2000.jpg"
    case fakeUrl = "https://test.com"
}

