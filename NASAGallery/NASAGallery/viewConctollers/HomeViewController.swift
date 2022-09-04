//
//  HomeViewController.swift
//  NASAGallery
//
//  Created by ahdivio mendes on 31/08/22.
//

import UIKit
typealias collectionViewSource = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout

class HomeViewController: UIViewController {
    let collectionViewCellName = "collectionViewCell"
    // HomeViewModel Delegate
    var modelDelegate: HomeViewModelInterface?
    // ------------
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSource()
        initaliseModel()
        
    }
}

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
    
    func generateCGFSize() -> CGFloat{
        let size = CGSize(width: 128.0, height: 128.0)
        let CGF = size.height * size.width
        return CGF
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



extension HomeViewController {
    
    func initaliseModel() {
        self.modelDelegate = HomeViewModel()
    }
    
    func setDelegateAndDataSource() {
        collectionView.dataSource = self
        collectionView.delegate  = self
    }
    
    
    func pushViewController(index: Int) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController else {
            return
        }
        vc.intialiseModel()
        vc.fetchModelData(model: self.modelDelegate!.getModelData, index: index)
        self.present(vc, animated: true, completion: nil)
    }
}


extension CGFloat {
    func generateCGFSize() -> CGFloat{
        let size = CGSize(width: 128.0, height: 128.0)
        let CGF = size.height * size.width
        return CGF
    }
}
