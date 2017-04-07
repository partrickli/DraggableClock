import UIKit

public protocol Renderer {
    
    func move(to point: CGPoint)
    
    func addLine(to point: CGPoint)
    
    func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)

    func addCurve(to endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint)
    
}

extension Renderer {
    func circle(with center: CGPoint, radius: CGFloat) {
        addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }
}

public protocol Drawable {
    func draw(on renderer: Renderer)
}

extension UIBezierPath: Renderer {}
