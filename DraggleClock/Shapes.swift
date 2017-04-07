import UIKit


//Circle

public struct Circle {
    let center: CGPoint
    let radius: CGFloat
    
    public init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
    }
}

extension Circle: Drawable {
    public func draw(on renderer: Renderer) {
        renderer.move(to: center + CGVector(dx: radius, dy: 0))
        renderer.circle(with: center, radius: radius)
    }
}

extension Circle: CustomPlaygroundQuickLookable {}

//directional line

public struct DirectionalLine {
    let start: CGPoint
    let end: CGPoint
    
    public init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}

extension DirectionalLine: Drawable {
    public func draw(on renderer: Renderer) {
        renderer.move(to: start)
        renderer.addLine(to: end)
    }
}

extension DirectionalLine: CustomPlaygroundQuickLookable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        return PlaygroundQuickLook.bezierPath(path)
    }
}

// Arc

public struct Arc {
    public let center: CGPoint
    public let radius: CGFloat
    public let angle: CGFloat
    
    public init(center: CGPoint, radius: CGFloat, angle: CGFloat) {
        self.center = center
        self.radius = radius
        self.angle = angle
    }
}

extension Arc: Drawable {
    public func draw(on renderer: Renderer) {
        renderer.move(to: center + CGVector(dx: radius, dy: 0))
        renderer.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: angle, clockwise: false)
    }
}



//shared implementation for types which conform to Drawable
extension CustomPlaygroundQuickLookable where Self: Drawable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        let path = UIBezierPath()
        draw(on: path)
        return PlaygroundQuickLook.bezierPath(path)
    }
}
