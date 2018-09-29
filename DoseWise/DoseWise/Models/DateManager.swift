import Foundation

class DateManager{
    
    private let date = Date()
    private let calendar = Calendar.current
    private var components = DateComponents()

    init(){
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }
    init(day: Int, hour: Int){
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = hour
        components.day = day
    }
    func getDate() -> Date {
        return date
    }
    
    func getCurrentDay() -> String{
        return String(components.day!)
    }
    
    func getCurrentMonth() -> String{
        return Const.MONTHS[components.month! - 1]
    }
    func getCurrentHour() -> Int{
        return components.hour!
    }
    func getCurrentMinutes() -> Int{
        return components.minute!
    }
    func getCurrentSec() -> Int{
        return components.second!
    }
}
