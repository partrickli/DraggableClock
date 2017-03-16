//
//  ViewController.swift
//  DraggleClock
//
//  Created by liguiyan on 2017/3/14.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    var someTime: Time?
    
    @IBOutlet weak var clockView: ClockView!

    override func viewDidLoad() {
        super.viewDidLoad()
        someTime = Time(hour: 2, minute: 30)
        clockView.time = someTime ?? Time(hour: 3, minute: 1)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.someTime?.tick()
            self.clockView.time = self.someTime ?? Time(hour: 3, minute: 1)
        })
        
        //gesture recognizers
        //pinch to zoom clock
        let zoomRecognizer = UIPinchGestureRecognizer(target: clockView, action: #selector(ClockView.zoomClock(recognizer:)))
        clockView.addGestureRecognizer(zoomRecognizer)
        //pan to move hand
        let handDragRecognizer = UIPanGestureRecognizer(target: clockView, action: #selector(ClockView.dragHand(recognizer:)))
    }

    //

}

