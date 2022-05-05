//
//  Actions.swift
//  CoreAnimator_Starter
//
//  Created by Kasun Gayashan on 04/03/2022.
//  Copyright © 2022 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class GradientColorAction: NSObject, CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        let layer = anObject as! CAGradientLayer
        let colorChange = CABasicAnimation(keyPath: AnimationHelper.gradientColors)
        let finalColors = [UIColor.black.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor]
        colorChange.duration = 2.0
        colorChange.fromValue = layer.colors
        colorChange.toValue = finalColors
        colorChange.fillMode = kCAFillModeBackwards
        colorChange.beginTime = AnimationHelper.addDelay(time: 4.0)
        layer.colors = finalColors
        layer.add(colorChange, forKey: "gradient_color_swap")
    }
}

class GradientLocationAction: NSObject, CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        let layer = anObject as! CAGradientLayer
        let changeLocation = CABasicAnimation(keyPath: AnimationHelper.gradientLocations)
        let finalLocation: [NSNumber] = [0.0, 0.9, 1.0]
        changeLocation.duration = 2.0
        changeLocation.fromValue = layer.locations
        changeLocation.toValue = finalLocation
        changeLocation.fillMode = kCAFillModeBackwards
        changeLocation.beginTime = AnimationHelper.addDelay(time: 4.0)
        layer.locations = finalLocation
        layer.add(changeLocation, forKey: "gradient_location")
    }
}

