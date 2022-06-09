//
//  Jelly.swift
//  Day2-3-exercise
//
//  Created by Quyen Lu on 08/06/2022.
//

import Foundation
import UIKit


class  Jelly {
    var timer: Timer?
    var  imageViewJelly: UIImageView?
    var workItem: DispatchWorkItem?

    init(imageViewJelly: UIImageView) {
        self.imageViewJelly = imageViewJelly
        self.imageViewJelly?.frame.origin.x = UIScreen.main.bounds.width
    }
    
    func start(interval: Double, update: @escaping (_ x:CGFloat ) -> Void) {
        if (timer != nil) {
            timer?.invalidate()
        }
        if (workItem != nil) {
            workItem!.cancel()
        }
                
        workItem = DispatchWorkItem {
            DispatchQueue.main.async { [self] in
                self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [self] _ in
                    self.imageViewJelly!.frame.origin.x -= 1
                    update(self.imageViewJelly!.frame.origin.x)
                }
            }
        }
        DispatchQueue.global().async(execute: workItem!)
    }
    
    func stop() {
        if (timer != nil) {
            timer?.invalidate()
        }
        if (workItem != nil) {
            workItem!.cancel()
        }
    }
    
    
}
