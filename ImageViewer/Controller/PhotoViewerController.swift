//
//  PhotoViewerController.swift
//  ImageViewer
//
//  Created by Gavin Butler on 30-10-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

class PhotoViewerController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = photo.image
    }
    
    @IBAction func launchPhotoZoomController(_ sender: UITapGestureRecognizer) {
        guard let storyboard = storyboard else { return }
        
        let zoomController = storyboard.instantiateViewController(withIdentifier: "PhotoZoomController") as! PhotoZoomController
        
        zoomController.modalTransitionStyle = .crossDissolve
        zoomController.photo = photo
        
        navigationController?.present(zoomController, animated: true, completion: nil)
        
    }
    
    
}
