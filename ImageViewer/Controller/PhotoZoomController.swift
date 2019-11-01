//
//  PhotoZoomController.swift
//  ImageViewer
//
//  Created by Gavin Butler on 31-10-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

class PhotoZoomController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = photo.image
    }
    
}
