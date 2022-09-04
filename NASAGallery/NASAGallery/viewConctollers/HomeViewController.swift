//
//  HomeViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import UIKit


class HomeViewController: UIViewController {
   
    //MARK: HomeViewModel Delegate
    var modelDelegate: HomeViewModelInterface?
   
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSource()
        initaliseModel()
        
    }
}





//MARK: collection View data Source and Delegate
extension HomeViewController: collectionViewSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        modelDelegate?.returnCountOfImages() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellName, for: indexPath) as! GalleryCelll
        cell.addShadow()
       
        modelDelegate?.getThumbanilUsingNuke(formCollection: indexPath, ImageView: cell.imageView, cellSize: generateCGFSize())
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushViewController(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                     layout collectionViewLayout: UICollectionViewLayout,
                                     sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width/3.0
        

        return CGSize(width: screenWidth - 3, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}




//MARK: Logic to initlaise Model
extension HomeViewController {
    
    //MARK: initialise modal
    func initaliseModel() {
        self.modelDelegate = HomeViewModel()
    }
    
    //MARK: sets collectionView delegate and data source to viewcontroller
    func setDelegateAndDataSource() {
        collectionView.dataSource = self
        collectionView.delegate  = self
    }
    
    
    //MARK: instantiates DetailedViewController and sets Modal
    func pushViewController(index: Int) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailedViewControllerID) as? DetailedViewController else {
            return
        }
        vc.intialiseModel()
        vc.fetchModelData(model: self.modelDelegate!.getModelData, index: index)
        self.present(vc, animated: true, completion: nil)
    }
}


