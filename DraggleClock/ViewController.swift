//
//  ViewController.swift
//  DraggleClock
//
//  Created by liguiyan on 2017/3/14.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    var currentTime: Time = Time(hour: 0, minute: 0) {
        didSet {
//            timeLabel.text = currentTime.description
//            clockView.hour = currentTime.hour
//            clockView.minute = currentTime.minute
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
        currentTime = Time(hour: 2, minute: 30)
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//            self.currentTime.tick()
//        })
    }

    //
    //clock hand drag hanler
    func dragHand(recognizer: UIPanGestureRecognizer) {
        print("pan gesture recognizer triggered !")
        switch recognizer.state {
        case .changed:
            
            //drag only finger on close enough to clock hand

            let panStart = recognizer.location(in: clockView)
            let translation = recognizer.translation(in: clockView)
            let draggedEnd = CGPoint(x: panStart.x + translation.x, y: panStart.y + translation.y)
            let ratio = clockView.minuteHand.length / (draggedEnd - clockView.center).magnitude
            let vector = draggedEnd - clockView.center
            let enlargedVector = CGVector(dx: vector.dx * ratio, dy: vector.dy * ratio)
            clockView.minuteHand.end = CGPoint(x: clockView.center.x + enlargedVector.dx, y: clockView.center.y + enlargedVector.dy)
            //
            currentTime.hour = clockView.hour
            currentTime.minute = clockView.minute


            recognizer.setTranslation(CGPoint.zero, in: clockView)
        default:
            break
        }
    }


}

