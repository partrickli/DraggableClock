import UIKit

//vector calculation utilization

//operators
//vector dot product operator
infix operator ⋅

public extension CGPoint {
    
    static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x - right.x, dy: left.y - right.y)
    }
    
    static func + (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }
}


public extension CGVector {
    // Vector dot product
    static func ⋅ (left: CGVector, right: CGVector) -> CGFloat {
        return left.dx * right.dx + left.dy * right.dy
    }
    // scalar multiplication
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }
    
    //mathimatical magnitude of vector
    var magnitude: CGFloat {
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    
    
    //rotate vector
    func rotated(at radian: CGFloat) -> CGVector {
        switch radian {
        case .pi / 2:
            return CGVector(dx: self.dy, dy: -self.dx)
        default:
            return CGVector(dx: 100, dy: 100)
        }
    }
}



extension CGVector {

    //transform angle to vector, for Hand and Scale need this. Every element related to angle on clock need this function to convert time to angle, then angle to drawing element. may further extent UIBezierPath to draw based on vector
    public var angle: CGFloat {
        get {
            return atan(dy / dx)
        }
        set {
            (dx, dy) = (magnitude * cos(newValue), magnitude * sin(newValue))
        }
    }
}

// customized initializer

extension CGVector {
    public static var normalized: CGVector {
        return CGVector(dx: 1, dy: 0)
    }
}



extension CGVector: CustomStringConvertible {
    public var description: String {
        return "vector: (\(dx), \(dy)), angle: \(angle)"
    }
}

