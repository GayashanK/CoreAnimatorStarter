//
//  ViewController.swift
//  CoreAnimator_Starter
//
//  Created by Harrison Ferrone on 20.05.18.
//  Copyright © 2018 Paradigm Shift Development, LLC. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInButton.round(cornerRadius: 10, borderWidth: 3, borderColor: UIColor.white)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signInButton.layer.position.y += AnimationHelper.screenBounds.height
        self.fadeInViews()
        
    }
    
    // MARK: User Actions
    @IBAction func SignInOnButtonPressed(_ sender: Any) {
        self.signInButton.layer.add(self.animateScale(), forKey: nil)
        segueToNextViewController(segueID: Constants.Segues.loadingVC, withDelay: 1.0)
    }
    
    // MARK: Animations
    func fadeInViews() {
        let fadeIn = AnimationHelper.basicFadeInAnimation()
        fadeIn.delegate = self
        self.titleLabel.layer.add(fadeIn, forKey: nil)
        fadeIn.beginTime = AnimationHelper.addDelay(time: 1.0)
        self.usernameField.layer.add(fadeIn, forKey: nil)
        fadeIn.beginTime = AnimationHelper.addDelay(time: 2.0)
        fadeIn.setValue("password", forKey: "animation_name")
        self.passwordField.layer.add(fadeIn, forKey: nil)
    }
    
    func animateButtonWithSpring() {
        let moveUp = CASpringAnimation(keyPath: AnimationHelper.posY)
        moveUp.delegate = self
        moveUp.fromValue = self.signInButton.layer.position.y + AnimationHelper.screenBounds.height
        print("y position - \(self.signInButton.layer.position.y)")
        moveUp.toValue = self.signInButton.layer.position.y - AnimationHelper.screenBounds.height
        moveUp.duration = moveUp.settlingDuration
//        moveUp.beginTime = AnimationHelper.addDelay(time: 2.5)
//        moveUp.fillMode = kCAFillModeBackwards
        //Spring Physics Properties
        moveUp.initialVelocity = 5
        moveUp.mass = 1
        moveUp.damping = 12
        moveUp.stiffness = 75
//        self.signInButton.layer.position.y -= AnimationHelper.screenBounds.height
        moveUp.setValue("sign_in", forKey: "animation_name")
        moveUp.setValue(self.signInButton.layer, forKey: "animation_layer")
        self.signInButton.layer.add(moveUp, forKey: nil)
    }
    
    func animateBorderColorPulse() -> CABasicAnimation {
        let fadeIn = CABasicAnimation(keyPath: AnimationHelper.borderColor)
        fadeIn.fromValue = UIColor.white.cgColor
        fadeIn.toValue = UIColor.clear.cgColor
        fadeIn.duration = 1.0
        fadeIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        fadeIn.speed = 2 //signInButton.layer.speed = 2 you can use this option also to speed up the animation and if you use both ways it will multiplied value as the speed value ex - fadeIn.speed = 3, signInButton.layer.speed = 3 now speed is 9
        fadeIn.repeatCount = .infinity
        fadeIn.autoreverses = true
        return fadeIn
    }
    
    func animateScale() -> CABasicAnimation {
        let scale = CASpringAnimation(keyPath: AnimationHelper.scale)
        scale.fromValue = 1.2
        scale.toValue = 1.0
        scale.duration = scale.settlingDuration
        scale.initialVelocity = 2
        scale.damping = 10
        scale.autoreverses = true
        return scale
    }
}

// MARK: Delegate Extensions
extension SignInViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let value = anim.value(forKey: "animation_name") as? String else { return }
        switch value {
        case "password":
            self.animateButtonWithSpring()
        case "sign_in":
            self.signInButton.layer.position.y -= AnimationHelper.screenBounds.height
            if let animLayer = anim.value(forKey: "animation_layer") as? CALayer {
                animLayer.add(self.animateBorderColorPulse(), forKey: "border_color_pulse")
                print(animLayer.animationKeys() ?? "no keys found")
            }
        default:
            break
        }
    }
}
