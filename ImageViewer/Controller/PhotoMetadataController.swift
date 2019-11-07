//
//  PhotoMetadataController.swift
//  ImageViewer
//
//  Created by Gavin Butler on 05-11-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit
import CoreData

class PhotoMetadataController: UITableViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    
    var displayPhoto: UIImage?
    var photo: UIImage?
    var filter: CIFilter?
    var tags = [String]()
    var context: NSManagedObjectContext?
    
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        photoImageView.image = displayPhoto
        
        if let tagsText = tagsTextField.text {
            self.tags = tags(from: tagsText)
        }
        
        applyFilter(scaleFactor: 0.25)
    }
    
    func applyFilter(scaleFactor scale: CGFloat) {
        guard let image = photo, let selectedFilter = filter else { return }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let size = CGSize(width: imageWidth * scale, height: imageHeight * scale)
        
        guard let resizedImage = image.resized(to: size) else { return }
        
        let filtrationImage = FiltrationImage(image: resizedImage)
        
        let operation = ImageFiltrationOperation(image: filtrationImage, filter: selectedFilter)
        
        operation.completionBlock = {
            if operation.isCancelled { return }
            self.photo = operation.filtrationImage.image
        }
        
        queue.addOperation(operation)
    }
    
    func setupNavigation() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(PhotoMetadataController.savePhoto))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func savePhoto() {
        guard let photo = photo, let context = context else { return }
        let caption = captionTextField.text
        
        let _ = Photo.with(photo, caption: caption, tags: tags, in: context)
        context.saveChanges()
        
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoMetadataController {
    func tags(from text: String) -> [String] {
        let commaSeparatedStrings = text.split(separator: ",").map(String.init)
        let lowerCaseTags = commaSeparatedStrings.map { $0.lowercased() }
        return lowerCaseTags.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
    }
}

