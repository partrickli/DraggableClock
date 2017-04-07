import Foundation

//try for clock view
public struct Time {
    
    public var hour: Int 

    public var minute: Int
    
    public mutating func increaseOneMinute() {
        if minute + 1 < 60 {
            minute += 1
        } else {
            minute = 0
            hour += 1
        }
    }
    
    public mutating func decreaseOneMinute() {
        if minute - 1 >= 0 {
            minute -= 1
        } else {
            minute = 59
            hour -= 1
        }
    }

    
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
    
    static func + (left: Time, right: Time) -> Time {
        if left.minute + right.minute < 60 {
            return Time(hour: left.hour + right.hour, minute: left.minute + right.minute)
        } else {
            return Time(hour: left.hour + right.hour + 1, minute: left.minute + right.minute - 60)
        }
    }
    
}

extension Time: CustomStringConvertible {
    public var description: String {
        return "\(hour) : \(minute)"
    }
}
