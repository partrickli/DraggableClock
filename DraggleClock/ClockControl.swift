//
//  ClockControl.swift
//  DraggleClock
//
//  Created by liguiyan on 2017/4/7.
//  Copyright © 2017年 partrick. All rights reserved.
//

import UIKit

@IBDesignable
class ClockControl: UIControl {
    @IBInspectable
    var clockColor: UIColor = UIColor.blue
    
    public var hour: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var minute: Int = 30 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var clockRadius: CGFloat {
        return bounds.size.width / 2 * 0.9
    }
    
    let minuteAngles = stride(from: 0, to: 60, by: 1).reduce([Int: Measurement<UnitAngle>]()) { (dict, index) in
        var d = dict
        d[index] = Measurement(value: Double(index * 6 - 90), unit: UnitAngle.degrees).converted(to: UnitAngle.radians)
        return d
    }
    
    let hourAngles = stride(from: 0, to: 12 * 60, by: 1).reduce([Int: Measurement<UnitAngle>]()) { (dict, index) in
        var d = dict
        d[index] = Measurement(value: Double(index) / 2 - 90, unit: UnitAngle.degrees).converted(to: UnitAngle.radians)
        return d
    }
    
    var minuteHand: DirectionalLine {
        let angle = minuteAngles[minute]?.converted(to: UnitAngle.radians).value ?? 0
        let vector = CGVector(dx: cos(angle), dy: sin(angle)) * clockRadius * 0.7
        return DirectionalLine(start: center, end: center + vector)
    }
    
    var hourHand: DirectionalLine {
        let angle = hourAngles[hour * 60 + minute]?.converted(to: UnitAngle.radians).value ?? 0 // to mend
        let vector = CGVector(dx: cos(angle), dy: sin(angle)) * clockRadius * 0.5
        return DirectionalLine(start: center, end: center + vector)
    }
    
    
    var circlar: Circle {
        return Circle(center: center, radius: clockRadius)
    }
    
    var markers: [DirectionalLine] {
        let angles = stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 30)
        let markders = angles.enumerated().map { (index, angle) -> DirectionalLine in
            let vector = CGVector(dx: cos(angle), dy: sin(angle)) * clockRadius
            let start = center + vector
            let end = index % 5 == 0 ? center + vector * 0.95 : center + vector * 0.98
            return DirectionalLine(start: start, end: end)
        }
        return markders
    }
    
    var hourNumbers: [(NSAttributedString, CGPoint)] {
        let hourAngles = stride(from: CGFloat.pi * 2, to: 0, by: -CGFloat.pi / 6).map {
            CGFloat.pi / 2 * 3 - $0
        }
        return hourAngles.enumerated().map { (index, angle) in
            let font = UIFont.systemFont(ofSize: 25)
            let attributes: [String: Any]? = [NSFontAttributeName: font]
            let i = index == 0 ? 12 : index
            let number = NSAttributedString(string: String(i), attributes: attributes)
            let fontOffSet = CGVector(dx: -number.size().width / 2, dy: -number.size().height / 2)
            let angleVector = CGVector(dx: clockRadius * cos(angle), dy: clockRadius * sin(angle)) * 0.8
            let position = (center + angleVector) + fontOffSet
            return (number, position)
        }
    }
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 2
        circlar.draw(on: path)
        markers.forEach { marker in
            marker.draw(on: path)
        }
        minuteHand.draw(on: path)
        hourHand.draw(on: path)
        
        hourNumbers.forEach { (number, position) in
            number.draw(at: position)
        }
        
        // drawing random points to simulate touch location
        
        //Circle(center: randomLocation, radius: 3).draw(on: path)
        
        clockColor.set()
        path.stroke()
    }
    
    //random point for test on clock
    
    let randomVector = CGVector(dx: (-1000..<1000).random, dy: (-1000..<1000).random)
    
    var randomLocation: CGPoint {
        return center + randomVector  * (clockRadius / 1000)
    }
    
    func angle(of vector: CGVector) -> Int {
        let angle = Measurement(value: atan2(Double(vector.dy), Double(vector.dx)), unit: UnitAngle.radians)
        let angleInDegree = angle.converted(to: UnitAngle.degrees)
        let angleIn360 = angleInDegree.value < 0 ? angleInDegree.value + 360 : angleInDegree.value
        return (Int(round(angleIn360)) + 90) % 360
    }
    
    //override uicontrol touch handling method to trace hand, for dragging clock minute hand.
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        return true
        //return false to disable tracking hand, if touch location is too far from minute hand                                              
        //left to be implemented
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let touchLocation = touch.location(in: self)
        print("minute of random location: \(angle(of: touchLocation - center) / 6)")
        minute = angle(of: touchLocation - center) / 6
        sendActions(for: .valueChanged)
        return true
    }

}
