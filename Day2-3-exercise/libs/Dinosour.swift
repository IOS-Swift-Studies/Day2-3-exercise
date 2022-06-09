//
//  Dinosour.swift
//  Day2-3-exercise
//
//  Created by Quyen Lu on 07/06/2022.
//

import Foundation
import AVFoundation
class StateEnum {
    static var STATE_IDLE = 1
    static var STATE_JUMP = 2
    static var STATE_DEAD = 3
    static var STATE_RUN  = 4
    static var STATE_WALK = 5
}

class DinosaurState {
    var type:Int?
    var fileName:String?
    var numSteps:Int?
    var currentStep: Int = 0
    var timer: Timer?
    var workItem: DispatchWorkItem?
    var player: AVAudioPlayer?
    var bgplayer: AVAudioPlayer?
    var myPlayer: MyPlayer?
    
    
    init() {
        self.type = StateEnum.STATE_IDLE
        self.fileName = "Idle"
        self.numSteps = 10
        currentStep = 1
        
    }
    
    @objc func finishVideo() {
        print("finish video")
    }
    
    func setState(type: Int) {
        if  (type == StateEnum.STATE_IDLE) {
            self.type = type
            self.fileName = "Idle"
            self.numSteps = 10
        }
        else if  (type == StateEnum.STATE_WALK) {
            self.type = type
            self.fileName = "Walk"
            self.numSteps = 10
            //playSound(fileName: "jump04")
        }
        else if  (type == StateEnum.STATE_JUMP) {
            self.type = type
            self.fileName = "Jump"
            self.numSteps = 12
            myPlayer!.playSound(fileName: "jump04")
        }
        else if  (type == StateEnum.STATE_DEAD) {
            self.type = type
            self.fileName = "Dead"
            self.numSteps = 12
            myPlayer!.playSound(fileName: "dead")
        }
        currentStep = 1
    }
    

    
    func run(update: @escaping (_ fileName: String, _ bDone:Bool, _ type:Int, _ index:Int, _ numStep:Int ) -> Void) {
        
        currentStep = 1
        //playBGSound(fileName: "background")
        myPlayer = MyPlayer()
        workItem = DispatchWorkItem {
            DispatchQueue.main.async { [self] in
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [] _ in
                    update("Dinosaur/\(self.fileName!) (\(self.currentStep))",
                           (self.currentStep  == self.numSteps) ? true : false,
                           self.type!, self.currentStep, self.numSteps!)
                    
                    if (self.type == StateEnum.STATE_IDLE || self.type == StateEnum.STATE_WALK) {
                        if  (self.currentStep >= self.numSteps!) {
                            self.currentStep = 1
                         }
                         else {
                             self.currentStep += 1
                         }
                    }
                    else  {
                        if  (self.type != StateEnum.STATE_DEAD && self.currentStep >= self.numSteps!) {
                            self.currentStep = 1
                            self.type = StateEnum.STATE_IDLE
                            self.fileName = "Idle"
                            self.numSteps = 10
                           
                         }
                         else {
                             self.currentStep += 1
                         }
                    }
                    if (self.myPlayer?.isBGSoundPlayer() == false) {
                        self.myPlayer!.playBGSound()
                    }
                    
                 }
           }
        }
        DispatchQueue.global().async(execute: workItem!)
       
    }
    
    func playBleedSound() {
        myPlayer!.playSound(fileName: "bleed")
    }

    func stop() {
        timer?.invalidate()
        DispatchQueue.main.async {
            self.workItem!.cancel()
            self.workItem = nil
            self.currentStep = 0
        }
        myPlayer!.stopSound()
        
    }
    
    func getState() -> Int {
        return self.type!
    }
    
    
//    func playSound(fileName: String) {
//
//        guard let path = Bundle.main.path(forResource: fileName, ofType:"wav") else {
//            return }
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//
//    func playBGSound(fileName: String) {
//
//        guard let path = Bundle.main.path(forResource: fileName, ofType:"wav") else {
//            return }
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            bgplayer = try AVAudioPlayer(contentsOf: url)
//            bgplayer?.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
    
}
