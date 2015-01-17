//
//  Filters.swift
//  Wrapping-Core-Image
//
//  Created by carlos on 17/1/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit

/*
CIFilter Reference
https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
*/

// imperative version

func sepiaToneFilterWithIntensity(intensity: Double, toCIImage image: CIImage) -> CIImage {
    let parameters = [
        kCIInputIntensityKey: intensity,
        kCIInputImageKey: image
    ]
    let filter = CIFilter(name: "CISepiaTone", withInputParameters: parameters)
    return filter.outputImage
}

func blurFilterWitRadius(radius:Double, toImage image:CIImage) -> CIImage {
    let parameters = [
        kCIInputRadiusKey: radius,
        kCIInputImageKey: image
    ]
    let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters)
    return filter.outputImage
}

func colorGeneratorFilterWithColor(color:UIColor) -> CIImage {
    let parameters = [kCIInputColorKey: CIColor(CGColor: color.CGColor)]
    let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
    return filter.outputImage
}

private func compositeSourceOverFilterWithBackgroundImage(bgImage:CIImage, andOverImage overImage:CIImage) -> CIImage {
    let parameters = [
        kCIInputImageKey: overImage,
        kCIInputBackgroundImageKey: bgImage
    ]
    let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters)
    // Since overImage can lacks in size, filter.outputImage also can lacks this.
    // With imageByCroppingToRect(bgImage.extent()) we apply the Extent of bgImage
    return filter.outputImage.imageByCroppingToRect(bgImage.extent())
}

func colorOverlayFilterWithColor(color:UIColor, toImage image:CIImage) -> CIImage {
    let overlay = colorGeneratorFilterWithColor(color)
    return compositeSourceOverFilterWithBackgroundImage(image, andOverImage: overlay)
}



// funtional way

typealias Filter = CIImage -> CIImage

func sepiaTone(intensity: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputIntensityKey: intensity,
            kCIInputImageKey: image
        ]
        let filter = CIFilter(name: "CISepiaTone", withInputParameters: parameters)
        return filter.outputImage
    }
}

func blur(radius: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters)
        return filter.outputImage
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let parameters = [kCIInputColorKey: CIColor(CGColor: color.CGColor)]
        let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
        return filter.outputImage
    }
}

private func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        let filter = CIFilter(name: "CISourceOverCompositing",
            withInputParameters: parameters)
        let cropRect = image.extent()
        return filter.outputImage.imageByCroppingToRect(cropRect)
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay)(image)
    }
}

// Function Composition

func composeFilters(filter1: Filter, filter2: Filter) -> Filter {
    return { img in filter2(filter1(img)) }
}

infix operator >>> { associativity left }

func >>> (filter1: Filter, filter2: Filter) -> Filter {
    return { img in filter2(filter1(img)) }
}






