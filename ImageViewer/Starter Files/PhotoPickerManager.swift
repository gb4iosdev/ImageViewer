//
//  PhotoPickerManager.swift
//  ImageViewer
//
//  Created by Gavin Butler on 29-10-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol PhotoPickerManagerDelegate: class {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}

class PhotoPickerManager: NSObject {
    
    //Set up the image picker. In this simple example we're either showing the camera or the photo library, but in a real world app you definitely want the user to be able to choose. Also, the camera doesn't work in simulators.
    private let imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            //imagePickerController.cameraDevice = .front  //Set which camera if required
            
        } else {
            picker.sourceType = .photoLibrary
        }
        //Restricts to images only (no videos)
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }()
    private let presentingController: UIViewController
    weak var delegate: PhotoPickerManagerDelegate?
    
    init(presentingViewController: UIViewController) {
        self.presentingController = presentingViewController
        super.init()
        //Always make self the delegate of the image picker.
        imagePickerController.delegate = self
    }
    
    //Present the image picker like any other view(controller)
    func presentPhotoPicker(animated: Bool) {
        presentingController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
}

//Need to conform to UINavigationControllerDelegate
extension PhotoPickerManager: UINavigationControllerDelegate {}

//Conform to UIImagePickerControllerDelegate
extension PhotoPickerManager: UIImagePickerControllerDelegate {
    
    //This gets called when you take a picture with the camera or choose one from the photo library.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Parse the image and typecast it to a UIImage to use somewhere else in your view controller
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        delegate?.manager(self, didPickImage: image)
    }
    
    //This delegate method gets called when you tap the "Cancel" button in the image picker. Just dismiss the image picker then.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
