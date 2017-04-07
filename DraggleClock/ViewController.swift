//
//  ViewController.swift
//  DraggleClock
//
//  Created by liguiyan on 2017/3/14.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //model
    var time: Time = Time(hour: 2, minute: 30) {
        didSet {
            clockControl.hour = time.hour
            clockControl.minute = time.minute
            timeLabel.text = "\(time.hour) : \(time.minute)"
        }
    }
   
    @IBOutlet weak var clockControl: ClockControl! {
        didSet {
            clockControl.addTarget(self, action: #selector(clockControlTimeChange(sender:)), for: .valueChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "\(time.hour) : \(time.minute)"
    }

    @IBOutlet weak var timeLabel: UILabel!
    
    // clock time value change handler 
    func clockControlTimeChange(sender: ClockControl) {
        //change model and update time on other control
        print("\(sender.hour) : \(sender.minute)")
        switch (time.minute, sender.minute) {
        case (59, 0):
            time.increaseOneMinute()
        case (0, 59):
            time.decreaseOneMinute()
        default:
            if sender.minute > time.minute {
                time.increaseOneMinute()
            } else {
                time.decreaseOneMinute()
            }
        }
    }
}




