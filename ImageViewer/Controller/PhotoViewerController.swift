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
}
