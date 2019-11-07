//
//  PhotoFilterController.swift
//  ImageViewer
//
//  Created by Gavin Butler on 01-11-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit
import CoreData

class PhotoFilterController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    private lazy var filteredImages: [CIImage] = {
        guard let image = self.photo else { return [] }
        let filteredImageBuilder = FilteredImageBuilder(image: image)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    let eaglContext = EAGLContext(api: .openGLES3)
    var managedObjectContext: NSManagedObjectContext?
    let queue = OperationQueue()
    
    var photo: UIImage?
    
    lazy var displayPhoto: UIImage? = {
        guard let image = photo else { return nil }
        
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
        setupNavigation()
    }
    
    func setupNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoFilterController.dismissPhotoFilterController))
        navigationItem.leftBarButtonItem = cancelButton
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(PhotoFilterController.launchPhotoMetadataController))
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc func launchPhotoMetadataController() {
        guard let photoMetadataController = storyboard?.instantiateViewController(withIdentifier: "PhotoMetadataController") as? PhotoMetadataController else { return }
        
        photoMetadataController.displayPhoto = photoImageView.image
        photoMetadataController.photo = self.photo
        photoMetadataController.filter = selectedFilter
        photoMetadataController.context = managedObjectContext

        navigationController?.pushViewController(photoMetadataController, animated: true)
    }
    
    
    @objc func dismissPhotoFilterController() {
        dismiss(animated: true, completion: nil)
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
        
        let image = FiltrationImage(image: displayPhoto!)
        let operation = ImageFiltrationOperation(image: image, filter: filter)
        
        operation.completionBlock = {
            if operation.isCancelled { return }
            
            DispatchQueue.main.async {
                self.photoImageView.image = operation.filtrationImage.image
            }
        }
        
        queue.addOperation(operation)
    }
}
