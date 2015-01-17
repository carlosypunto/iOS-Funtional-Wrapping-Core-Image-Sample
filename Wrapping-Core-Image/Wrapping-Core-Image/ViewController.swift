//
//  ViewController.swift
//  Wrapping-Core-Image
//
//  Created by carlos on 16/1/15.
//  Copyright (c) 2015 Carlos García. All rights reserved.
//

import UIKit

struct CellInfo {
    let text: String
    let image: UIImage
}

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var layout: UICollectionViewFlowLayout!
    
    var cellInfos:[CellInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        
        let originalImage = CIImage(CGImage: UIImage(named: "Hypnotoad")?.CGImage)!
        
        let intensity = 0.8
        let blurRadius = 5.0
        let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        
        
        // Imperative version ------------------------------------------------------------------------------
        let imperativeSepia = sepiaToneFilterWithIntensity(intensity, toCIImage: originalImage)
        let imperativeBlured = blurFilterWitRadius(blurRadius, toImage: originalImage)
        let imperativeComposited = colorOverlayFilterWithColor(overlayColor, toImage: imperativeBlured)
        
        
        // Funtional way -----------------------------------------------------------------------------------
        let blurredImage = blur(blurRadius)(originalImage)
        let overlaidImage = colorOverlay(overlayColor)(blurredImage)
        
        // Functional mode advantage, filter composition
        
        let confusedCompositionOfFilters = colorOverlay(overlayColor)(blur(blurRadius)(sepiaTone(intensity)(originalImage)))
        
        let lessConfusedCompositionOfFilters = composeFilters(composeFilters(sepiaTone(intensity), blur(blurRadius)), colorOverlay(overlayColor))
        let compositionOfFilters1 = lessConfusedCompositionOfFilters(originalImage)
        
        let simpleCompositionOfFilters = sepiaTone(intensity) >>> blur(blurRadius) >>> colorOverlay(overlayColor)
        let compositionOfFilters2 = simpleCompositionOfFilters(originalImage)
        
        
        
        
        // -------------------------------------------------------------------------------------------------
        // Add CellInfos to array
        
        
        if let image = UIImage(CIImage: originalImage) {
            cellInfos.append(CellInfo(text: "Original Image", image: image))
        }
        if let image = UIImage(CIImage: imperativeSepia) {
            cellInfos.append(CellInfo(text: "Imperative Sepia Image", image: image))
        }
        if let image = UIImage(CIImage: imperativeBlured) {
            cellInfos.append(CellInfo(text: "Imperative Blured Image", image: image))
        }
        if let image = UIImage(CIImage: imperativeComposited) {
            cellInfos.append(CellInfo(text: "Imperative Compound Image", image: image))
        }
        
        
        if let image = UIImage(CIImage: blurredImage) {
            cellInfos.append(CellInfo(text: "Blured Image", image: image))
        }
        if let image = UIImage(CIImage: overlaidImage) {
            cellInfos.append(CellInfo(text: "Compound Image", image: image))
        }
        
        
        if let image = UIImage(CIImage: confusedCompositionOfFilters) {
            cellInfos.append(CellInfo(text: "Confused composition", image: image))
        }
        if let image = UIImage(CIImage: compositionOfFilters1) {
            cellInfos.append(CellInfo(text: "Simple composition", image: image))
        }
        if let image = UIImage(CIImage: compositionOfFilters2) {
            cellInfos.append(CellInfo(text: "Most simple composition", image: image))
        }
        
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("leCell", forIndexPath: indexPath) as Cell
        let cellInfo = cellInfos[indexPath.item]
        cell.label.text = cellInfo.text
        cell.imageView.image = cellInfo.image
        return cell
    }
    
    
    // MARK: Helper
    
    private func setupCollectionViewLayout() {
        let side = min(view.bounds.size.width, view.bounds.size.height) / 2 - 10
        layout.itemSize = CGSize(width: side, height: side)
    }


}

