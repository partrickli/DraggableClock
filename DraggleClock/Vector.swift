import UIKit

//vector calculation utilization

public extension CGPoint {
    
    static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x - right.x, dy: left.y - right.y)
    }
    
    func distance(to line: Line) -> CGFloat {
        let vector = self - line.start
        let orthogonal = (line.end - line.start).rotated(at: .pi / 2)
        return vector.project(on: orthogonal)
    }

}

public struct Line {
    let start: CGPoint
    let end: CGPoint
    
    public init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}

//vector dot product operator
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
