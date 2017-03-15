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
    }
    public static let RadianPerAngle = CGFloat.pi / 180
    
    public var time = Time(hour: 0, minute: 0) {
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
        let angle: CGFloat
        let length: CGFloat
        
        var radian: CGFloat {
            return angle * Constants.RadianPerAngle
        }
        
        var start: CGPoint {
            return origin
        }
        
        var end: CGPoint {
            let endX = origin.x + length * cos(radian - CGFloat.pi / 2)
            let endY = origin.y + length * sin(radian - CGFloat.pi / 2)
            return CGPoint(x: endX, y: endY)
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
    
    var minuteHand: Hand {
        let AnglePerMinute: CGFloat = 6.0
        let angle = CGFloat(time.minute) * AnglePerMinute
        let length = clockRadius * Constants.MinuteHandLengthToRadius
        let hand = Hand(origin: center, angle: angle, length: length)
        return hand
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

}

extension ClockView: CustomPlaygroundQuickLookable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        return .view(self)
        
//        let path = UIBezierPath()
//        path.move(to: hourHand.end)
//        path.addLine(to: hourHand.start)
//        path.addLine(to: minuteHand.end)
//        path.lineWidth = 3
//        return .bezierPath(path)
        
        
//        let currentAngle = minuteHand.radian / Clock.RadianPerAngle
//        return .text("angle \(currentAngle)")
    }
}


