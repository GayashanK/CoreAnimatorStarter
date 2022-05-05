//
//  LoadingViewController.swift
//  CoreAnimator_Starter
//
//  Created by Harrison Ferrone on 05.06.18.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var setupLabel: UILabel!
    //Rotation values: [0.0, .pi/2, Double.pi * 3/2, Double.pi * 2]
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clockImage.round(cornerRadius: clockImage.frame.size.width/2, borderWidth: 4, borderColor: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let titleAnimGroup = CAAnimationGroup()
        titleAnimGroup.duration = 1.5
        titleAnimGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        titleAnimGroup.repeatCount = .infinity
        titleAnimGroup.autoreverses = true
        titleAnimGroup.animations = [self.postionPulse(), self.scalePulse()]
        self.loadingLabel.layer.add(titleAnimGroup, forKey: "title_animation_group")
        let clockAnimGroup = CAAnimationGroup()
        clockAnimGroup.repeatCount = .infinity
        clockAnimGroup.duration = 5.0
        clockAnimGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        clockAnimGroup.animations = [self.createKeyFrameColorAnimation(), self.bounceKeyFrameAnimation(), self.roationKeyFrameAnimation()]
        self.clockImage.layer.add(clockAnimGroup, forKey: "clock_animation_group")
//        self.clockImage.layer.add(self.createKeyFrameColorAnimation(), forKey: "color_change_border")
//        self.clockImage.layer.add(self.bounceKeyFrameAnimation(), forKey: "bounce")
        self.delayForSeconds(delay: 2.0) {
            self.animateViewTransitions()
        }
        segueToNextViewController(segueID: Constants.Segues.dashboardVC, withDelay: 7.0)
    }
    
    // MARK: Group Animations
    func postionPulse() -> CABasicAnimation {
        let posY = CABasicAnimation(keyPath: AnimationHelper.posY)
        posY.fromValue = self.loadingLabel.layer.position.y - 20
        posY.toValue = self.loadingLabel.layer.position.y + 20
        return posY
    }
    
    func scalePulse() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: AnimationHelper.scale)
        scale.fromValue = 1.1
        scale.toValue = 1.0
        return scale
    }
    
    // MARK: Keyframe Animations
    func createKeyFrameColorAnimation() -> CAKeyframeAnimation {
        let colorChange = CAKeyframeAnimation(keyPath: AnimationHelper.borderColor)
        colorChange.duration = 1.5
//        colorChange.beginTime = AnimationHelper.addDelay(time: 1.0)
        colorChange.repeatCount = .infinity
        colorChange.values = [
            UIColor.white.cgColor,
            UIColor.yellow.cgColor,
            UIColor.red.cgColor,
            UIColor.black.cgColor
        ]
        colorChange.keyTimes = [0.0, 0.25, 0.5, 1.0]
        return colorChange
    }
    
    func bounceKeyFrameAnimation() -> CAKeyframeAnimation {
        let bounce = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        bounce.delegate = self
//        bounce.duration = 3.0
        bounce.values = [
            NSValue(cgPoint: CGPoint(x: 25, y: AnimationHelper.screenBounds.height - 25)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width / 4.0 + 25, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width / 2.0 + 25, y: AnimationHelper.screenBounds.height - 25)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width / 4.0 * 3.0 + 25, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width + 25, y: AnimationHelper.screenBounds.height - 25)),
        ]
        bounce.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        bounce.setValue("bounce_animation", forKey: "animation_name")
        return bounce
    }
    
    func roationKeyFrameAnimation() -> CAKeyframeAnimation {
        let rotation = CAKeyframeAnimation(keyPath: AnimationHelper.rotation)
        rotation.values = [0.0, .pi/2.0, Double.pi, .pi * 3.0/2.0]
        rotation.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        rotation.setValue("rotation", forKey: "animation_name")
        return rotation
    }
    
    // MARK: Transitions
    func animateViewTransitions() {
        let viewTransition = CATransition()
        viewTransition.type = kCATransitionReveal //this is a documented transition there are also some non documented transitions, you can use them as following example
//        viewTransition.type = "cube"
        viewTransition.subtype = kCATransitionFromLeft
        viewTransition.duration = 1.5
        viewTransition.startProgress = 0.4
        viewTransition.endProgress = 0.8
        self.loadingLabel.layer.add(viewTransition, forKey: "reveal_left")
        self.setupLabel.layer.add(viewTransition, forKey: "reveal_left")
        self.loadingLabel.isHidden = true
        self.setupLabel.isHidden = false
    }
}

// MARK: Delegate Extensions
extension LoadingViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animName = anim.value(forKey: "animation_name") as? String else { return }
        switch animName {
        case "bounce_animation":
//            self.clockImage.layer.position = CGPoint(x: AnimationHelper.screenBounds.width + 200, y: AnimationHelper.screenBounds.height - 100)
            break
        case "reveal_left":
            break
        default:
            break
        }
    }
}
