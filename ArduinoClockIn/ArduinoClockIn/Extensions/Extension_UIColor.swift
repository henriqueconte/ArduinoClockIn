//
//  Extension_UIColor.swift
//  ArduinoClockIn
//
//  Created by Rafael Ferreira on 05/03/20.
//  Copyright © 2020 Henrique Figueiredo Conte. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func colorWithGradient(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> UIColor {
        // create the background layer that will hold the gradient
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = frame
        backgroundGradientLayer.startPoint = startPoint
        backgroundGradientLayer.endPoint = endPoint
        
        // we create an array of CG colors from out UIColor array
        let cgColors = colors.map({$0.cgColor})
        backgroundGradientLayer.colors = cgColors
        UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
        backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: backgroundColorImage!)
    }
}
