import Foundation
import UserNotifications

//class makes a notification based on hours and minutes
class NotificationReminderManager{
    
    let dateManager : DateManager!
    let center : UNUserNotificationCenter!
    
    //Initialize a notification center and date manager at initialization
    init(){
        dateManager = DateManager()
        center = UNUserNotificationCenter.current()
    }
    
    //Function to add a reminder
    func addReminder(time:String){
        //Setting up the notification center with necessary details.
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Take your scheduled pill in DoseWise"
        content.sound = UNNotificationSound.default()
        
        //Convert given date into a date object ised to set the reminder
        let dateString = "\(dateManager.getCurrentMonthNumber())-\(dateManager.getCurrentDay()) \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        let dateObj = dateFormatter.date(from: dateString)
        
        //Set the trigger to be executed daily
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute], from: dateObj!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        //Adding the notification based on time with uique identifier
        let identifier = "pillNotification\(time)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        //Error message if an error happen when launching the notification
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("cant launch notification")
            }
        })
    }
    //Remove reminder if pill is taken before the set time for the notification 
    func removeReminder(time:String){
        let identifier = "pillNotification\(time)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
