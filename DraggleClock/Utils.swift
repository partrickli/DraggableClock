import UIKit

extension Range where Bound == CGFloat {
    public var random: CGFloat {
        let shift = upperBound - lowerBound
        return CGFloat(arc4random_uniform(UInt32(shift))) + lowerBound
    }
}
