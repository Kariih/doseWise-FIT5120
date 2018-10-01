import Foundation
import UserNotifications

class NotificationReminderManager{
    
    let dateManager : DateManager!
    let center : UNUserNotificationCenter!
    
    init(){
        dateManager = DateManager()
        center = UNUserNotificationCenter.current()
    }
    
    func addReminder(time:String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Take your scheduled pill in DoseWise"
        content.sound = UNNotificationSound.default()
        
      //  var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        //triggerDate.second = triggerDate.second! + 5
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let dateString = "\(dateManager.getCurrentMonthNumber())-\(dateManager.getCurrentDay()) \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let dateObj = dateFormatter.date(from: dateString)
        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute], from: dateObj!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        
        let identifier = "pillNotification\(time)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("cant launch notification")
            }
        })
    }
    func removeReminder(time:String){
        let identifier = "pillNotification\(time)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
