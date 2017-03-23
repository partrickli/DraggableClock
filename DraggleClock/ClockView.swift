import UIKit
import Darwin

struct Constants {
    static let RadianPerAngle: CGFloat = CGFloat.pi / 180 //half circle is .pi, 180 degree
    static let HourHandLengthToRadius: CGFloat = 0.6
    static let MinuteHandLengthToRadius: CGFloat = 0.8
    static let MinuteHandAnglePerMinute: CGFloat = 6.0
    static let HourHandAnglePerHour: CGFloat = 30 // 360/12 = 30
    static let HourHandAnglePerMinute: CGFloat = 0.5 // 30/60 = 0.5
}

public struct Hand {
    var start: CGPoint = CGPoint.zero
    var angle: CGFloat = 0
    var length: CGFloat = 0

    var radian: CGFloat {
        get {
            return angle * Constants.RadianPerAngle
        }
        set {
            angle = newValue / Constants.RadianPerAngle
            print(" radian set ")
        }
    }
    
    public var end: CGPoint {
        get {
            let endX = start.x + length * cos(radian - CGFloat.pi / 2)
            let endY = start.y + length * sin(radian - CGFloat.pi / 2)
            return CGPoint(x: endX, y: endY)
        }
        set {
            print("end set")
            length = (newValue - start).magnitude
            radian = atan(newValue.y / newValue.x) + CGFloat.pi / 2
        }
    }
    
    var rangeX: ClosedRange<CGFloat> {
        return min(start.x, end.x)...max(start.x, end.x)
    }
    
    var rangeY: ClosedRange<CGFloat> {
        return min(start.y, end.y)...max(start.y, end.y)
    }
    
    public var path: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

@IBDesignable
public class ClockView: UIView {
    public var clockRadius: Double = 100 {
        didSet {
            setNeedsDisplay()
        }
    }// Double for inspectable, for cgfloat doesn't support key value coding

    
    public var hour: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    public var minute: Int = 0 {
        didSet {
            print("minute set from \(oldValue) to \(minute)")
            setNeedsDisplay()
        }
    }
    public var hourHand: Hand {
        get {
            return Hand(start: center,
                        angle: Constants.HourHandAnglePerHour * CGFloat(hour % 12) + Constants.HourHandAnglePerMinute * CGFloat(minute),
                        length: CGFloat(clockRadius) * Constants.HourHandLengthToRadius)
        }
    }
    public var minuteHand: Hand {
        get {
            return Hand(start: center,
                        angle: CGFloat(minute) * Constants.MinuteHandAnglePerMinute,
                        length: CGFloat(clockRadius) * Constants.MinuteHandLengthToRadius)
        }
        set {
            minute = Int(newValue.angle / Constants.MinuteHandAnglePerMinute)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    

//    how to draw view
    override public func draw(_ rect: CGRect) {
        UIColor.orange.set()
        let hourPath = hourHand.path
        hourPath.lineWidth = 2
        hourPath.stroke()
        minuteHand.path.stroke()
        
    }
    
    //clock zooming handler
    func zoomClock(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            print("zoom clock")
            clockRadius *= Double(recognizer.scale)
            recognizer.scale = 1
            print(recognizer.scale)
        default:
            break
        }
    }
}








