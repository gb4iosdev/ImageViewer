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
    
    private lazy var filteredImages: [CIImage] = {
        guard let image = self.photo else { return [] }
        let filteredImageBuilder = FilteredImageBuilder(image: image)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    let eaglContext = EAGLContext(api: .openGLES3)
    
    var photo: UIImage?
    
    lazy var displayPhoto: UIImage? = {
        guard let image = photo else { return }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let screenWidth = UIScreen.main.bounds.width
        
        let scaledRatio = screenWidth/imageWidth
        let scaledHeight = scaledRatio * imageHeight
        let size = CGSize(width: screenWidth, height: scaledHeight)
        
        return image.resized(to: size)
    }()
    var selectedFilter: CIFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = displayPhoto
        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
    }
}

extension PhotoFilterController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilteredImageCell.reuseIdentifier, for: indexPath) as! FilteredImageCell
        
        let image = filteredImages[indexPath.row]
        cell.eaglContext = eaglContext
        cell.image = image
        
        return cell
    }
}

extension PhotoFilterController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = PhotoFilter.defaultFilters[indexPath.row]
        self.selectedFilter = filter
        
    }
}
