//
//  PhotoFilterController.swift
//  ImageViewer
//
//  Created by Gavin Butler on 01-11-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    var context: CIContext!
    let filtrationQueue = OperationQueue()
    var filtrationsInProgress = Set<IndexPath>()
    
    let filters = PhotoFilter.defaultFilters
    
    lazy var filtrationImages: [FiltrationImage] = {
        guard let image = self.photo else { return [] }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let scaledWidth: CGFloat = 100
        let scaledRatio = scaledWidth / imageWidth
        let scaledHeight = scaledRatio * imageHeight
        
        let rect = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
        
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return []
        }
        UIGraphicsEndImageContext()
        
        return self.filters.map { _ in return FiltrationImage(image: scaledImage)}
    }()
    
    var photo: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = photo
        filtersCollectionView.dataSource = self
    }
}

extension PhotoFilterController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtrationImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
        
        let filtrationImage = filtrationImages[indexPath.row]
        
        if filtrationImage.filterState == .filtered {
            cell.imageView.image = filtrationImage.image
        } else {
            cell.imageView.image = nil
        }
        
        let filter = filters[indexPath.row]
        
        switch filtrationImage.filterState {
        case .noFilter:
            startFiltrationOperationForImage(filtrationImage, withFilter: filter, at: indexPath)
        case .filtered: break
        }
        
        return cell
    }
    
    func startFiltrationOperationForImage(_ image: FiltrationImage, withFilter filter: CIFilter, at indexPath: IndexPath) {
        if filtrationsInProgress.contains(indexPath) { return }
        
        let operation = ImageFiltrationOperation(image: image, filter: filter)
        
        operation.completionBlock = {
            if operation.isCancelled { return }
            
            DispatchQueue.main.async {
                self.filtrationsInProgress.remove(indexPath)
                self.filtersCollectionView.reloadItems(at: [indexPath])
            }
        }
        
        filtrationsInProgress.insert(indexPath)
        filtrationQueue.addOperation(operation)
    }
}
