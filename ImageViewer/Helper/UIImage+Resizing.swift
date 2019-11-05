//
//  UIImage+Resizing.swift
//  ImageViewer
//
//  Created by Gavin Butler on 05-11-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
