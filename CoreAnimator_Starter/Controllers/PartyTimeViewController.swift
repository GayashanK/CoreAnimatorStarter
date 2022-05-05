//
//  PartyTimeViewController.swift
//  CoreAnimator_Starter
//
//  Created by Harrison Ferrone on 13.06.18.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class PartyTimeViewController: UIViewController {
    
    // Labels
    var partyLabel: UILabel!
    var timeLabel: UILabel!
    var celebrateLabel: UILabel!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        partyLabel = UILabel()
        partyLabel.layer.anchorPoint.x = 1.0
        partyLabel.frame = CGRect(x: AnimationHelper.screenBounds.midX - 150, y: 100, width: 150, height: 50)
        partyLabel.text = "Party"
        partyLabel.font = UIFont(name: "Arial-Bold", size: 20)
        partyLabel.textColor = UIColor.white
        partyLabel.textAlignment = .center
        partyLabel.layer.borderColor = UIColor.white.cgColor
        partyLabel.layer.borderWidth = 3.0
        
        timeLabel = UILabel()
        timeLabel.layer.anchorPoint.x = 0.0 // Modify label's X anchor point, because even though we're rotating the transform around the y-axis, the X anchor is determining the rotation origin. Before we set the frame, we should set anchorpoint, by default an X anchor is set to center, or 0.5. Now, a value of one is gonna put the anchor at the right edge of the label. Now why did I put this before the frame? Well if you're modifying anchor points in code, you need to do this before the frame, otherwise the view or the layer will be rendered relative to that changed anchor point, this can give you odd and unexpected results.
        timeLabel.frame = CGRect(x: AnimationHelper.screenBounds.midX, y: 100, width: 150, height: 50)
        timeLabel.text = "Time"
        timeLabel.font = UIFont(name: "Arial-Bold", size: 20)
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        timeLabel.layer.borderColor = UIColor.white.cgColor
        timeLabel.layer.borderWidth = 3.0
        
        celebrateLabel = UILabel()
        celebrateLabel.frame = CGRect(x: AnimationHelper.screenBounds.midX - 75, y: AnimationHelper.screenBounds.midY, width: 150, height: 150)
        celebrateLabel.text = "CELEBRATE!"
        celebrateLabel.font = UIFont(name: "Arial", size: 18)
        celebrateLabel.textColor = UIColor.white
        celebrateLabel.textAlignment = .center
        celebrateLabel.layer.borderColor = UIColor.white.cgColor
        celebrateLabel.layer.borderWidth = 5.0
        
        view.addSubview(partyLabel)
        view.addSubview(timeLabel)
        view.addSubview(celebrateLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.positionLabel()
//        self.view.layer.sublayerTransform = create3dPerspectiveTransform(cameraDistance: 800)
        self.celebrateLabel.layer.transform = create3DMultiTransform()
        self.animateLabel3D()
        self.createFireworkEmitter()
    }
    
    // MARK: 3D Animations
//    Every layer has a transform property that handles its scaling, rotation, and position.
//    Core Animation has the ability to display layers in three dimensions along the X,Y, and Z axes.
    
//    Auto layout doesn't play particularly well with manual changes to transform properties. If you absolutely have to use auto layout in your 3-D animations, use a container view that you pin with auto layout and programatically create the views or layers you want to animate inside that container view.
    func create3dPerspectiveTransform(cameraDistance: CGFloat) -> CATransform3D {
        var viewPersprective = CATransform3DIdentity
        viewPersprective.m34 = -1.0/cameraDistance // Layer transforms are 2-D matrices under the hood. So, m34 is referencing the third row, fourth column of that matrix, which is the Z axis perspective.
        return viewPersprective
    }
    
    func positionLabel() {
        let rotationAngle = CGFloat.pi/4.0
        var rotatedTransform = create3dPerspectiveTransform(cameraDistance: 800)
        rotatedTransform = CATransform3DRotate(rotatedTransform, rotationAngle, 0.0, 1.0, 0.0)
        partyLabel.layer.transform = rotatedTransform
    }
    
    func create3DMultiTransform() -> CATransform3D {
        var multiTransform = create3dPerspectiveTransform(cameraDistance: 1000)
        multiTransform = CATransform3DTranslate(multiTransform, 0.0, 150, 200)
        multiTransform = CATransform3DRotate(multiTransform, .pi/2.5, 1.0, 0.0, 0.0)
        multiTransform = CATransform3DScale(multiTransform, 1.7, 1.3, 1.0)
        return multiTransform
    }
    
    func animateLabel3D() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.partyLabel.layer.shouldRasterize = false
            print("Rasterizing off..")
        }
        var perspectiveTransform = create3dPerspectiveTransform(cameraDistance: 800)
        perspectiveTransform = CATransform3DRotate(perspectiveTransform, .pi/4.0, 0.0, -1.0, 0.0)
        let rotate3D = CABasicAnimation(keyPath: AnimationHelper.transform)
        rotate3D.duration = 2.0
        rotate3D.fromValue = self.timeLabel.layer.transform
        rotate3D.toValue = perspectiveTransform
        rotate3D.beginTime = AnimationHelper.addDelay(time: 1.0)
        rotate3D.fillMode = kCAFillModeBackwards
        self.partyLabel.layer.shouldRasterize = true
        self.partyLabel.layer.rasterizationScale = UIScreen.main.scale
        print("Rasterizing on..")
        self.timeLabel.layer.transform = perspectiveTransform
        self.timeLabel.layer.add(rotate3D, forKey: "rotate_3D")
        CATransaction.commit()
    }

    // MARK: Particle Emitter
    func createFireworkEmitter() {
        let fireworksEmitter = CAEmitterLayer()
        fireworksEmitter.frame = self.view.bounds
        fireworksEmitter.emitterPosition = CGPoint(x: AnimationHelper.screenBounds.midX, y: AnimationHelper.screenBounds.midY)
        fireworksEmitter.emitterSize = CGSize(width: 150, height: 150)
        fireworksEmitter.emitterShape = kCAEmitterLayerPoint
        fireworksEmitter.emitterCells = [createFirework(fireworkColor: .red), createFirework(fireworkColor: .orange), createFirework(fireworkColor: .yellow)]
        self.view.layer.addSublayer(fireworksEmitter)
    }
    
    func createFirework(fireworkColor: UIColor) -> CAEmitterCell {
        let fireworkCell = CAEmitterCell()
        fireworkCell.contents = UIImage(named: "firework.png")?.cgImage
        fireworkCell.birthRate = 1.5
        fireworkCell.lifetime = 1.5
        fireworkCell.yAcceleration = 100
        fireworkCell.xAcceleration = 15
        fireworkCell.velocity = 50
        fireworkCell.velocityRange = 100
        fireworkCell.emissionLongitude = -.pi/2.0
        fireworkCell.emissionLatitude = .pi/2.0
        fireworkCell.emissionRange = .pi/2.0
        fireworkCell.scale = 0.75
        fireworkCell.scaleRange = 0.1
        fireworkCell.scaleSpeed = -0.1
        fireworkCell.alphaRange = 0.8
        fireworkCell.alphaSpeed = -0.1
        fireworkCell.color = fireworkColor.cgColor
        return fireworkCell
    }
}
