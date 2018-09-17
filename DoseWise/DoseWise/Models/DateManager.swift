import Foundation

class DateManager{
    
    let date = Date()
    let calendar = Calendar.current
    var components = DateComponents()

    init(){
        components = calendar.dateComponents([.year, .month, .day], from: date)
    }
    
    func getCurrentDay() -> String{
        return String(components.day!)
    }
    
    func getCurrentMonth() -> String{
        let months = ["January", "Februar", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[components.month! - 1]
    }
}
