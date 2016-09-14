import Foundation

public class WWTimeflow {
    public static var calendar: Calendar = {
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = timeZoneUTC
        return cal
    }()
    public static var timeZone: TimeZone {
        set { calendar.timeZone = newValue }
        get { return calendar.timeZone }
    }
    public static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.timeZone = timeZone
        df.calendar = calendar
        return df
    }
    private static let timeZoneUTC: TimeZone = TimeZone(abbreviation: "UTC")!
    
    public private(set) var value: Int
    public private(set) var unit: Calendar.Component
    
    init(value: Int, unit: Calendar.Component) {
        self.value = value
        self.unit = unit
    }
}

//extension Date: Comparable {}

public func == (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedSame
}

public func < (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

public func > (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedDescending
}

public func <= (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != .orderedDescending
}

public func >= (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) != .orderedAscending
}

public func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSince(rhs)
}

public func + (lhs: Date, rhs: WWTimeflow) -> Date {
    return WWTimeflow.calendar.date(byAdding: rhs.unit, value: rhs.value, to: lhs)!
}

public func - (lhs: Date, rhs: WWTimeflow) -> Date {
    return WWTimeflow.calendar.date(byAdding: rhs.unit, value: -rhs.value, to: lhs)!
}

public extension Int {
    public var year: WWTimeflow {
        return WWTimeflow(value: self, unit: .year)
    }
    public var years: WWTimeflow {
        return year
    }
    
    public var month: WWTimeflow {
        return WWTimeflow(value: self, unit: .month)
    }
    public var months: WWTimeflow {
        return month
    }
    
    public var week: WWTimeflow {
        return WWTimeflow(value: self, unit: .weekOfYear)
    }
    public var weeks: WWTimeflow {
        return week
    }
    
    public var day: WWTimeflow {
        return WWTimeflow(value: self, unit: .day)
    }
    public var days: WWTimeflow {
        return day
    }
    
    public var hour: WWTimeflow {
        return WWTimeflow(value: self, unit: .hour)
    }
    public var hours: WWTimeflow {
        return hour
    }
    
    public var minute: WWTimeflow {
        return WWTimeflow(value: self, unit: .minute)
    }
    public var minutes: WWTimeflow {
        return minute
    }
    
    public var second: WWTimeflow {
        return WWTimeflow(value: self, unit: .second)
    }
    public var seconds: WWTimeflow {
        return second
    }
    
    public var ordinal: String {
        let ones: Int = self % 10
        let tens: Int = (self / 10) % 10
        if (tens == 1) {
            return "th"
        }
        else if (ones == 1) {
            return "st"
        }
        else if (ones == 2) {
            return "nd"
        }
        else if (ones == 3) {
            return "rd"
        }
        return "th"
    }
}

public extension String {
    public func dateFromFormat(format: String) -> Date? {
        let formatter = WWTimeflow.dateFormatter
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

public extension Date {
    public func stringFromFormat(format: String) -> String {
        let formatter = WWTimeflow.dateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    public func differenceWith(date: Date, inUnit unit: Calendar.Component) -> Int {
        return WWTimeflow.calendar.dateComponents([unit], from: self, to: date).value(for: unit)!
    }
    
    public func components(units: Set<Calendar.Component>) -> DateComponents {
        return WWTimeflow.calendar.dateComponents(units, from: self)
    }
    
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let d = Date().change(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        self.init(timeIntervalSinceReferenceDate: d.timeIntervalSinceReferenceDate)
    }
    
    public init(year: Int, month: Int, day: Int) {
        let d = Date().change(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        self.init(timeIntervalSinceReferenceDate: d.timeIntervalSinceReferenceDate)
    }
    
    public func change(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        var components = self.components(units: [.year, .month, .day, .hour, .minute, .second])
        components.year = year ?? self.year
        components.month = month ?? self.month
        components.day = day ?? self.day
        components.hour = hour ?? self.hour
        components.minute = minute ?? self.minute
        components.second = second ?? self.second
        return WWTimeflow.calendar.date(from: components)!
    }
    
    public func change(weekday: Int) -> Date {
        return self - (self.weekday - weekday).days
    }
    
    public var year: Int {
        return components(units: [.year]).year!
    }
    public var month: Int {
        return components(units: [.month]).month!
    }
    public var day: Int {
        return components(units: [.day]).day!
    }
    public var hour: Int {
        return components(units: [.hour]).hour!
    }
    public var minute: Int {
        return components(units: [.minute]).minute!
    }
    public var second: Int {
        return components(units: [.second]).second!
    }
    public var weekday: Int {
        return components(units: [.weekday]).weekday!
    }
    
    public var beginningOfYear: Date {
        return change(month: 1, day: 1, hour: 0, minute: 0, second: 0)
    }
    public var endOfYear: Date {
        return (beginningOfYear + 1.year).addingTimeInterval(-1)
    }
    
    public var beginningOfMonth: Date {
        return change(day: 1, hour: 0, minute: 0, second: 0)
    }
    public var endOfMonth: Date {
        return (beginningOfMonth + 1.month).addingTimeInterval(-1)
    }
    
    public var beginningOfWeek: Date {
        return change(weekday: 1).beginningOfDay
    }
    public var endOfWeek: Date {
        return (beginningOfWeek + 1.week).addingTimeInterval(-1)
    }
    
    public var beginningOfDay: Date {
        return change(hour: 0, minute: 0, second: 0)
    }
    public var endOfDay: Date {
        return (beginningOfDay + 1.day).addingTimeInterval(-1)
    }
    
    public var beginningOfHour: Date {
        return change(minute: 0, second: 0)
    }
    public var endOfHour: Date {
        return (beginningOfHour + 1.hour).addingTimeInterval(-1)
    }
    
    public var beginningOfMinute: Date {
        return change(second: 0)
    }
    public var endOfMinute: Date {
        return (beginningOfMinute + 1.minute).addingTimeInterval(-1)
    }
}
