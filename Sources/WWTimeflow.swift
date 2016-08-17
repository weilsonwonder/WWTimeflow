import Foundation

public class WWTimeflow {
    public static var calendar: NSCalendar = {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = timeZoneUTC
        return cal
    }()
    public static var timeZone: NSTimeZone {
        set { calendar.timeZone = newValue }
        get { return calendar.timeZone }
    }
    public static var dateFormatter: NSDateFormatter {
        let df = NSDateFormatter()
        df.timeZone = timeZone
        df.calendar = calendar
        return df
    }
    private static let timeZoneUTC: NSTimeZone = NSTimeZone(abbreviation: "UTC")!
    
    public private(set) var value: Int
    public private(set) var unit: NSCalendarUnit
    
    private init(value: Int, unit: NSCalendarUnit) {
        self.value = value
        self.unit = unit
    }
}

extension NSDate: Comparable {}

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedSame
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func > (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

public func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) != .OrderedDescending
}

public func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) != .OrderedAscending
}

public func - (lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceDate(rhs)
}

public func + (lhs: NSDate, rhs: WWTimeflow) -> NSDate {
    return WWTimeflow.calendar.dateByAddingUnit(rhs.unit, value: rhs.value, toDate: lhs, options: .SearchBackwards)!
}

public func - (lhs: NSDate, rhs: WWTimeflow) -> NSDate {
    return WWTimeflow.calendar.dateByAddingUnit(rhs.unit, value: -rhs.value, toDate: lhs, options: .SearchBackwards)!
}

public extension Int {
    public var year: WWTimeflow {
        return WWTimeflow(value: self, unit: .Year)
    }
    public var years: WWTimeflow {
        return year
    }
    
    public var month: WWTimeflow {
        return WWTimeflow(value: self, unit: .Month)
    }
    public var months: WWTimeflow {
        return month
    }
    
    public var week: WWTimeflow {
        return WWTimeflow(value: self, unit: .WeekOfYear)
    }
    public var weeks: WWTimeflow {
        return week
    }
    
    public var day: WWTimeflow {
        return WWTimeflow(value: self, unit: .Day)
    }
    public var days: WWTimeflow {
        return day
    }
    
    public var hour: WWTimeflow {
        return WWTimeflow(value: self, unit: .Hour)
    }
    public var hours: WWTimeflow {
        return hour
    }
    
    public var minute: WWTimeflow {
        return WWTimeflow(value: self, unit: .Minute)
    }
    public var minutes: WWTimeflow {
        return minute
    }
    
    public var second: WWTimeflow {
        return WWTimeflow(value: self, unit: .Second)
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
    public func dateFromFormat(format: String) -> NSDate? {
        let formatter = WWTimeflow.dateFormatter
        formatter.dateFormat = format
        return formatter.dateFromString(self)
    }
}

public extension NSDate {
    public func stringFromFormat(format: String) -> String {
        let formatter = WWTimeflow.dateFormatter
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    public func differenceWith(date: NSDate, inUnit unit: NSCalendarUnit) -> Int {
        return WWTimeflow.calendar.components(unit, fromDate: self, toDate: date, options: .SearchBackwards).valueForComponent(unit)
    }
    
    public func components(units: NSCalendarUnit) -> NSDateComponents {
        return WWTimeflow.calendar.components(units, fromDate: self)
    }
    
    public convenience init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        let d = NSDate().change(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        self.init(timeIntervalSinceReferenceDate: d.timeIntervalSinceReferenceDate)
    }
    
    public convenience init(year: Int, month: Int, day: Int) {
        let d = NSDate().change(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        self.init(timeIntervalSinceReferenceDate: d.timeIntervalSinceReferenceDate)
    }
    
    public func change(year year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> NSDate {
        let components = self.components([.Year, .Month, .Day, .Hour, .Minute, .Second])
        components.year = year ?? self.year
        components.month = month ?? self.month
        components.day = day ?? self.day
        components.hour = hour ?? self.hour
        components.minute = minute ?? self.minute
        components.second = second ?? self.second
        return WWTimeflow.calendar.dateFromComponents(components)!
    }
    
    public func change(weekday weekday: Int) -> NSDate {
        return self - (self.weekday - weekday).days
    }
    
    public var year: Int {
        return components(.Year).year
    }
    public var month: Int {
        return components(.Month).month
    }
    public var day: Int {
        return components(.Day).day
    }
    public var hour: Int {
        return components(.Hour).hour
    }
    public var minute: Int {
        return components(.Minute).minute
    }
    public var second: Int {
        return components(.Second).second
    }
    public var weekday: Int {
        return components(.Weekday).weekday
    }
    
    public var beginningOfYear: NSDate {
        return change(month: 1, day: 1, hour: 0, minute: 0, second: 0)
    }
    public var endOfYear: NSDate {
        return (beginningOfYear + 1.year).dateByAddingTimeInterval(-1)
    }
    
    public var beginningOfMonth: NSDate {
        return change(day: 1, hour: 0, minute: 0, second: 0)
    }
    public var endOfMonth: NSDate {
        return (beginningOfMonth + 1.month).dateByAddingTimeInterval(-1)
    }
    
    public var beginningOfWeek: NSDate {
        return change(weekday: 1).beginningOfDay
    }
    public var endOfWeek: NSDate {
        return (beginningOfWeek + 1.week).dateByAddingTimeInterval(-1)
    }
    
    public var beginningOfDay: NSDate {
        return change(hour: 0, minute: 0, second: 0)
    }
    public var endOfDay: NSDate {
        return (beginningOfDay + 1.day).dateByAddingTimeInterval(-1)
    }
    
    public var beginningOfHour: NSDate {
        return change(minute: 0, second: 0)
    }
    public var endOfHour: NSDate {
        return (beginningOfHour + 1.hour).dateByAddingTimeInterval(-1)
    }
    
    public var beginningOfMinute: NSDate {
        return change(second: 0)
    }
    public var endOfMinute: NSDate {
        return (beginningOfMinute + 1.minute).dateByAddingTimeInterval(-1)
    }
}
