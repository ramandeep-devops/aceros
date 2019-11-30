
import Foundation

enum Day: Int{
    case Sun = 0
    case Mon = 1
    case Tue = 2
    case Wed = 3
    case Thu = 4
    case Fri = 5
    case Sat = 6
    
}

class DateClass{
    
    static let shared = DateClass()
    
    func getWeekDay(date: String) -> Int{
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "d-MMM"
        guard let result = formatter1.date(from: date) else { return 0}
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: result)
        return  myComponents.weekday ?? 0
        
    }
    
    func getTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return  formatter.string(from: date)
    }
    
    
    
    func getDayOfWeek()->[String]{
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "d-MMM"
        let result = formatter1.string(from: date)
        let formatter  = DateFormatter()
        formatter.dateFormat = "d-MMM"
        
        let todayDate = formatter.date(from: result)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday ?? 0
        
        switch weekDay
        {
        case 1:
            return ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        case 2:
            return ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        case 3:
            return ["Tue","Wed","Thu","Fri","Sat","Sun","Mon"]
        case 4:
            return ["Wedn","Thu","Fri","Sat","Sun","Mon","Tue"]
        case 5:
            return ["Thu","Fri","Sat","Sun","Mon","Tue","Wed"]
        case 6:
            return ["Fri","Sat","Sun","Mon","Tue","Wed","Thu"]
        case 7:
            return ["Sat","Sun","Mon","Tue","Wed","Thu","Fri"]
        default:
//            debugPrint("Error fetching days")
            return ["Day"]
        }
        
    }
    func toMillis(from date : Date) -> String {
        //Int((self.timeIntervalSince1970 * 1000.0).rounded())
        return "\(Int64((date.timeIntervalSince1970 * 1000.0).rounded()))"
    }
    
    func previousDayDifference(from date : Date, format : String) -> String {
        
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if ifDateisInPreviousSevenDays(date: date) { return DateClass.shared.toString(from: date, usingFormat: "EEEE") }
        else { return DateClass.shared.toString(from: date, usingFormat: format) }
    }
    
    func ifDateisInPreviousSevenDays(date : Date) -> Bool{
        
        let threshold = Date(timeIntervalSinceNow: -(7*24*60*60))
        return date >= threshold
    }
    
    func toString(from date: Date?, usingFormat format : String) -> String {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let formattedDate : String = dateFormatter.string(from: date ?? Date())
        return formattedDate
    }
}
