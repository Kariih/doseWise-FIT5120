import Foundation
import UserNotifications

class NotificationReminderManager{
    
    let dateManager : DateManager!
    
    init(){
        dateManager = DateManager()
    }
    
    func addReminder(time:String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Take your scheduled pill in DoseWise"
        content.sound = UNNotificationSound.default()
        
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        triggerDate.second = triggerDate.second! + 5
        
       // let triggerDaily = Calendar.current.dateComponents([hour, .minute, .second], from: date)
       // let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        print("seconds: \(triggerDate.second!)")
        
        let identifier = "pillNotification\(time)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("cant launch notification")
            }
        })
        func removeReminder(time:String){
            //remove
        }
        
    }
    
}
