//
//  ViewController.swift
//  Day2-3-exercise
//
//  Created by Quyen Lu on 05/06/2022.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var imageViewDinosaur: UIImageView!

    @IBOutlet weak var imageViewJelly: UIImageView!
    var idleItem: DispatchWorkItem?
    var timer: Timer?
    var dinosaurState: DinosaurState = DinosaurState()
    var jelly: Jelly?
    var dinosaurOrgPosition: CGPoint?
    var score: Int = 3
    var interval:Double?
    
    @IBOutlet weak var viewGameOver: UIView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var dinosaurYConstant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        score = 3
        interval = 0.004
        jelly = Jelly(imageViewJelly: imageViewJelly)
        
        dinosaurState.run(update: {(urlString, bDone, type, index, numSteps) in self.updateDinosaurState(urlString: urlString, bDone: bDone, type: type, index: index, numSteps: numSteps)})
        dinosaurOrgPosition = imageViewDinosaur.frame.origin
        
        jelly!.start(interval: interval!, update: updateJelly)
        print(dinosaurYConstant.constant)
        
    }
    
    
    
    func updateDinosaurState(urlString: String, bDone: Bool, type: Int, index: Int, numSteps: Int) {
        if (type == StateEnum.STATE_JUMP) {
            if (index == 1 || index == numSteps) {
                dinosaurYConstant.constant = 53
            }
            else {
                dinosaurYConstant.constant = 130
            }
            self.imageViewDinosaur.image = UIImage(named: urlString)
        }
        else {
            self.imageViewDinosaur.image = UIImage(named: urlString)
        }
        
        if (type == StateEnum.STATE_DEAD && bDone == true) {
            dinosaurState.stop()
            jelly?.stop()
            self.viewGameOver.isHidden = false
        }
        
        
    }
    
    func updateJelly(x: CGFloat) {
        if (self.dinosaurState.getState() != StateEnum.STATE_DEAD) {
            if (imageViewDinosaur.frame.origin.x + imageViewDinosaur.frame.size.width/2-15 == x) {
                if (self.dinosaurState.getState() == StateEnum.STATE_JUMP) {
                    score += 1
                    labelScore.text = String(score)
                }
                else {
                    score -= 1
                    labelScore.text = String(score)
                    dinosaurState.playBleedSound()
                    if (score <= 0) {
                        dinosaurState.setState(type: StateEnum.STATE_DEAD)
                    }
                    
                }
                
            }
            else if (self.imageViewJelly!.frame.origin.x < 50) {
                self.imageViewJelly?.frame.origin.x = UIScreen.main.bounds.width
                
                if (self.interval! > 0.0015) {
                    self.interval! -= 0.0002
                }
                    
                self.jelly!.start(interval: self.interval!, update: self.updateJelly)
                
            }
        }
    }
    
    
    
    
    @IBAction func WalkOnPress(_ sender: Any) {
        dinosaurState.setState(type: StateEnum.STATE_WALK)
        
        
    }
    
    
    @IBAction func JumpOnPress(_ sender: Any) {
        dinosaurState.setState(type: StateEnum.STATE_JUMP)
    }
}

