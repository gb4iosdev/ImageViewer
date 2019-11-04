//
//  FilteredImageBuilder.swift
//  ImageViewer
//
//  Created by Gavin Butler on 03-11-2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import CoreImage
import UIKit

//Apply the filters to the chosen image
class FilteredImageBuilder {
    
    private let image: UIImage
    private let context: CIContext
    
    init(image: UIImage, context: CIContext) {
        self.image = image
        self.context = context
    }
    
    func applyFilter(_ filter: CIFilter) -> CGImage? {
        
        guard let inputImage = image.ciImage ?? CIImage(image: self.image) else { return nil }
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return nil }
        
        return context.createCGImage(outputImage, from: inputImage.extent)
    }
    
    func image(withFilters filters: [CIFilter]) -> [CGImage] {
        return filters.compactMap { applyFilter($0) }
    }
    
    func imageWithDefaultFilters() -> [CGImage] {
        return image(withFilters: PhotoFilter.defaultFilters)
    }
    
    
}
