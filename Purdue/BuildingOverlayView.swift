//
//  BuildingOverlayView.swift
//  Purdue
//
//  Created by George Lo on 12/22/14.
//  Copyright (c) 2014 Purdue University. All rights reserved.
//

import UIKit
import MapKit

class BuildingOverlayView: MKOverlayRenderer {
    
    var overlayImage: UIImage?
   
    init(overlay: MKOverlay, overlayImage: UIImage) {
        super.init(overlay: overlay)
        self.overlayImage = overlayImage
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        let imageRef = self.overlayImage!.CGImage
        let rect = self.rectForMapRect(self.overlay.boundingMapRect)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -rect.size.height)
        CGContextDrawImage(context, rect, imageRef)
        
        
    }
    
}
