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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            if let cell = sender as? UICollectionViewCell, let indexPath = photosCollectionView.indexPath(for: cell), let pageViewController = segue.destination as? PhotoPageController {
                pageViewController.photos = dataSource.photos
                pageViewController.indexOfCurrentPhoto = indexPath.row
            }
        }
    }
}

extension PhotoListController: PhotoPickerManagerDelegate {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage) {
        //let _ = Photo.with(image, in: context)
        //First assign the image somewhere/to something and then dismiss the image picker
        //context.saveChanges()
        
        
        //Always dismiss the image picker when you're done with it
        manager.dismissPhotoPicker(animated: true) {
            guard let photoFilterController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoFilterController") as? PhotoFilterController else {
                return }
            
            photoFilterController.photo = image
            photoFilterController.managedObjectContext = self.context
            
            let navController = UINavigationController(rootViewController: photoFilterController)
            
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
}

