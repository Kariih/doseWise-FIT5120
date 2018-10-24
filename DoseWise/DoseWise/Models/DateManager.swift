import Foundation

//keep track of the different data elements needed in the application
class DateManager{
    
    private let date = Date()
    private let calendar = Calendar.current
    private var components = DateComponents()

    //Create a new calendar object based on todays date
    init(){
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }
    //create a new calendar object with a specified hour and day, used for daily notifications
    init(day: Int, hour: Int){
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = hour
        components.day = day
    }
    //Return a date object with todays date
    func getDate() -> Date {
        return date
    }
    //Function returns todays day as string
    func getCurrentDay() -> String{
        return String(components.day!)
    }
    //Function returns current month as text, such as "January", "February"
    func getCurrentMonthTxt() -> String{
        return Const.MONTHS[components.month! - 1]
    }
    //Function returns month as integer
    func getCurrentMonthNumber() -> Int{
        return components.month!
    }
    //Function returns hour given for date, either current or set hour
    func getCurrentHour() -> Int{
        return components.hour!
    }
    //Function returns the minute given for date, either current or set minute
    func getCurrentMinutes() -> Int{
        return components.minute!
    }
    //Function returns the current secound
    func getCurrentSec() -> Int{
        return components.second!
    }
    //Function returns current year
    func getCurrentYear() -> Int{
        return components.year!
    }
}
