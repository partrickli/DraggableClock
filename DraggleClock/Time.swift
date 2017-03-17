import Foundation

//try for clock view
public struct Time {
    
    public var hour: Int
    public var minute: Int
    
    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    public mutating func tick() {
        if minute + 1 < 60 {
            minute += 1
        } else {
            minute = 0
            hour += 1
        }
    }
}

extension Time: CustomStringConvertible {
    public var description: String {
        return "\(hour) : \(minute)"
    }
}
