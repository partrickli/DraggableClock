import UIKit

//customizing operator



public extension CGPoint {
    static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x - right.x, dy: left.y - right.y)
    }
}

infix operator ⋅

public extension CGVector {
    // Vector dot product
    static func ⋅ (left: CGVector, right: CGVector) -> CGFloat {
        return left.dx * right.dx + left.dy * right.dy
    }
    
    //mathimatical magnitude of vector
    var magnitude: CGFloat {
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    //project on anther vector
    func project(on other: CGVector) -> CGFloat {
        return (self ⋅ other) / other.magnitude
    }
}
