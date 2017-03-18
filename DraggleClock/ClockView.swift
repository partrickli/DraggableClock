import UIKit

@IBDesignable
public class ClockView: UIView {
    @IBInspectable
    public var clockRadius: CGFloat = 100
    public var clockOrigin = CGPoint(x: 0, y: 0)

    struct Constants {
        static let RadianPerAngle: CGFloat = CGFloat.pi / 180 //half circle is .pi, 180 degree
        static let HourHandLengthToRadius: CGFloat = 0.6
        static let MinuteHandLengthToRadius: CGFloat = 0.8
        static let MinuteHandAnglePerMinute: CGFloat = 6.0
    }
    
    var clockCenter: CGPoint {
        return center
    }
    
    public static let RadianPerAngle = CGFloat.pi / 180
    
    public var time = Time(hour: 2, minute: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    struct Hand {
        let origin: CGPoint
        var angle: CGFloat
        let length: CGFloat
        
        var radian: CGFloat {
            get {
                return angle * Constants.RadianPerAngle
            }
            set {
                angle = newValue / Constants.RadianPerAngle
            }
        }
        
        var start: CGPoint {
            return origin
        }
        
        var end: CGPoint {
            let endX = origin.x + length * cos(radian - CGFloat.pi / 2)
            let endY = origin.y + length * sin(radian - CGFloat.pi / 2)
            return CGPoint(x: endX, y: endY)
        }
        
        var rangeX: ClosedRange<CGFloat> {
            return min(start.x, end.x)...max(start.x, end.x)
        }
        
        var rangeY: ClosedRange<CGFloat> {
            return min(start.y, end.y)...max(start.y, end.y)
        }
    }
    
    var hourHand: Hand {
        let AnglePerHour: CGFloat = 30 // 360/12 = 30
        let AnglePerMinute: CGFloat = 0.5 // 30/60 = 0.5
        let angle = AnglePerHour * CGFloat(time.hour % 12) + AnglePerMinute * CGFloat(time.minute)
        let length = clockRadius * Constants.HourHandLengthToRadius
        let hand = Hand(origin: center, angle: angle, length: length)
        return hand
    }
    

    
    var minuteHand: Hand { // better to be stored property, and property observer
        get {
            let angle = CGFloat(time.minute) * Constants.MinuteHandAnglePerMinute
            let length = clockRadius * Constants.MinuteHandLengthToRadius
            let hand = Hand(origin: center, angle: angle, length: length)
            return hand
        }
        set {
            time.minute = Int(newValue.angle / Constants.MinuteHandAnglePerMinute)
            setNeedsDisplay()
        }
    }
    
    
//    how to draw view
    override public func draw(_ rect: CGRect) {
        UIColor.blue.set()
        let path = UIBezierPath()
        path.move(to: hourHand.end)
        path.addLine(to: hourHand.start)
        path.addLine(to: minuteHand.end)
        path.lineWidth = 3
        path.stroke()
        
    }
    
//    override public func draw(_ rect: CGRect) {
//        let path = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: 50, startAngle: 0, endAngle: .pi, clockwise: true)
//        path.lineWidth = 5
//        UIColor.blue.set()
//        path.stroke()
//    }
    
    //clock zooming handler
    func zoomClock(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            print("zoom clock")
            clockRadius *= recognizer.scale
            recognizer.scale = 1
            print(recognizer.scale)
        default:
            break
        }
    }
    
    //
    //            guard case minuteHand.rangeX = focus.x, case minuteHand.rangeY = focus.y else {
    //                print("out of hand bounds")
    //                break
    //            }
    func timeShifted(for recognizer: UIPanGestureRecognizer) -> Time {
        let focus = recognizer.location(in: self)
        let distanceToMinuteHand = focus.distance(to: Line(start: minuteHand.start, end: minuteHand.end))
        guard distanceToMinuteHand < minuteHand.length / 5 else {
            print("not close enough to hand")
            return Time(hour: 0, minute: 0)
        }
        let translation = recognizer.translation(in: self)
        let orthogonalOfHand = (minuteHand.end - minuteHand.start).rotated(at: .pi / 2)
        let timeDragRadian = -(translation - CGPoint.zero).project(on: orthogonalOfHand) / (focus - center).magnitude
        return Time(hour: 0, minute: Int(timeDragRadian / (Constants.MinuteHandAnglePerMinute * Constants.RadianPerAngle)))
    }

}



