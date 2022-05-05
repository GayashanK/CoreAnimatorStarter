//
//  DashboardViewController.swift
//  CoreAnimator_Starter
//
//  Created by Harrison Ferrone on 13.06.18.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // Shape layers
    let gradientLayer = CAGradientLayer()
    var circle = CAShapeLayer()
    var square = CAShapeLayer()
    var triangle = CAShapeLayer()
    
    // Gradient colors
    let colors = [
        UIColor.blue.cgColor,
        UIColor.darkGray.cgColor,
        UIColor.black.cgColor
    ]
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Gradient setup
        gradientLayer.colors = colors
        gradientLayer.delegate = self
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Shape setup
        square = AnimationHelper.squareShapeLayer()
        view.layer.addSublayer(square)
        circle = AnimationHelper.circleShapeLayer()
        view.layer.addSublayer(circle)
//        self.gradientAnimation()
        self.animateLineDash()
        self.animateCircleByPath()
        self.animateCircleShapeChange()
        self.createReplicatorLayer()
        self.createCustomTransaction()
        self.createTextLayer()
    }
    
    func gradientAnimation() {
        let colorShift = CABasicAnimation(keyPath: AnimationHelper.gradientColors)
        colorShift.fromValue = colors
        colorShift.toValue = colors.reversed()
        colorShift.duration = 2.0
        colorShift.beginTime = AnimationHelper.addDelay(time: 2.0)
        colorShift.fillMode = kCAFillModeBackwards
        self.gradientLayer.colors = colors.reversed()
        self.gradientLayer.add(colorShift, forKey: "gradient_animation")
    }
    
    func animateLineDash() {
        let dash = CABasicAnimation(keyPath: AnimationHelper.dashPhase)
        dash.fromValue = 0
        dash.toValue = self.square.lineDashPattern?.reduce(0, {$0 + $1.intValue})
        dash.duration = 1.0
        dash.repeatCount = .infinity
        self.square.add(dash, forKey: "dash_animation")
    }
    
    func animateCircleByPath() {
        let circleMovement = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        circleMovement.repeatCount = .infinity
        circleMovement.duration = 3.0
        circleMovement.path = self.square.path
        circleMovement.calculationMode = kCAAnimationPaced
        self.circle.add(circleMovement, forKey: "key_path_animation")
    }
    
    func animateCircleShapeChange() {
        let squish = CABasicAnimation(keyPath: AnimationHelper.shapePath)
        squish.duration = 1.5
        squish.repeatCount = .infinity
        squish.autoreverses = true
        squish.toValue = UIBezierPath(roundedRect: CGRect(x: -50, y: -50, width: 100, height: 100), cornerRadius: 10).cgPath
        self.circle.add(squish, forKey: "squish_animation")
    }
    
    func createReplicatorLayer() {
        let replicator = CAReplicatorLayer()
        replicator.frame = CGRect(x: 0, y: AnimationHelper.screenBounds.height - 100, width: AnimationHelper.screenBounds.width, height: 100)
        replicator.masksToBounds = true
        view.layer.addSublayer(replicator)
        self.triangle = AnimationHelper.triangleShapeLayer()
        replicator.addSublayer(self.triangle)
        replicator.repeatCount = 4
        replicator.instanceDelay = TimeInterval(2.0)
        replicator.instanceTransform = CATransform3DMakeTranslation(100, 0, 0)
//        let pulse  = AnimationHelper.basicFadeInAnimation()
//        pulse.autoreverses = true
//        pulse.repeatCount = 3
//        self.triangle.add(pulse, forKey: "fade_pulse_animation")
    }
    
    func createTextLayer() {
        let titleLayer = CATextLayer()
        titleLayer.frame = CGRect(x: 0, y: 100, width: AnimationHelper.screenBounds.width, height: 100)
        titleLayer.string = "Dashboard"
        titleLayer.alignmentMode = "center"
        view.layer.addSublayer(titleLayer)
        let textColor = CABasicAnimation(keyPath: AnimationHelper.textColor)
        textColor.duration = 1.5
        textColor.fromValue = UIColor.white.cgColor
        textColor.toValue = UIColor.red.cgColor
        textColor.beginTime = AnimationHelper.addDelay(time: 2.0)
        textColor.fillMode = kCAFillModeBackwards
        titleLayer.foregroundColor = UIColor.red.cgColor
        titleLayer.add(textColor, forKey: "text_color_animation")
    }
    
    func createCustomTransaction() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.5)
        CATransaction.setCompletionBlock {
            print("Replicator animation completed.")
        }
        let pulse  = AnimationHelper.basicFadeInAnimation()
        pulse.autoreverses = true
        pulse.repeatCount = 3
        self.triangle.add(pulse, forKey: "fade_pulse_animation")
        CATransaction.commit()
    }
}

extension DashboardViewController: CALayerDelegate {
    func action(for layer: CALayer, forKey event: String) -> CAAction? {
        switch event {
        case kCAOnOrderIn:
            return GradientColorAction()
        case AnimationHelper.gradientLocations:
            return GradientLocationAction()
        default:
            break
        }
        
        return nil
    }
}
