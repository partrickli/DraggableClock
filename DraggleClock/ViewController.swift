//
//  ViewController.swift
//  DraggleClock
//
//  Created by liguiyan on 2017/3/14.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    var someTime: Time? {
        didSet {
            timeLabel.text = someTime?.description
            clockView.time = someTime ?? Time(hour: 0, minute: 0)
        }
    }
    
    @IBOutlet weak var clockView: ClockView! {
        didSet {
            //gesture recognizers
            //pinch to zoom clock
            let zoomRecognizer = UIPinchGestureRecognizer(target: clockView, action: #selector(ClockView.zoomClock(recognizer:)))
            clockView.addGestureRecognizer(zoomRecognizer)
            //pan to move hand
            let handDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.dragHand(recognizer:)))
            clockView.addGestureRecognizer(handDragRecognizer)
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        someTime = Time(hour: 2, minute: 30)
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//            self.someTime?.tick()
//        })
        

    }

    //
    //clock hand drag hanler
    func dragHand(recognizer: UIPanGestureRecognizer) {
        print("pan gesture recognizer triggered !")
        switch recognizer.state {
        case .changed:
            
            //drag only finger on close enough to clock hand
            let timeShift = clockView.timeShifted(for: recognizer)
            print("time shift: \(timeShift)")
            someTime = someTime! + timeShift
            recognizer.setTranslation(CGPoint.zero, in: clockView)
        default:
            break
        }
    }


}

