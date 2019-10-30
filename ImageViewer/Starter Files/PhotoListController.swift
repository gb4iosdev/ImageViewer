//
//  PhotoListController.swift
//  ImageViewer
//
//  Created by Pasan Premaratne on 9/26/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit
import CoreData

final class PhotoListController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    let context = CoreDataStack().managedObjectContext
    
    lazy var dataSource: PhotosDataSource = {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        return PhotosDataSource(fetchRequest: request, managedObjectContext: self.context, collectionView: self.photosCollectionView)
    }()
    
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.dataSource = dataSource
    }
    
    @IBAction func launchCamera(_ sender: UIButton) {
        photoPickerManager.presentPhotoPicker(animated: true)
    }
    
}

extension PhotoListController: PhotoPickerManagerDelegate {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        let _ = Photo.with(image, in: context)
        context.saveChanges()
        manager.dismissPhotoPicker(animated: true, completion: nil)
    }
}

