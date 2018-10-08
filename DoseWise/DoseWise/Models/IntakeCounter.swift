import Foundation
import UserNotifications
import UIKit

//this class check whether user forgot his past intakes of the day

class intakeCounter{
    let defaults = UserDefaults.standard
    let dateMana = DateManager()
    
    func confirming(isTaken:Bool,rowIndex:Int){
        var theRegister = defaults.array(forKey: "register")
        if isTaken {
            theRegister![rowIndex]=1
        } else {
            theRegister![rowIndex]=0
        }
        defaults.set(theRegister, forKey: "register")
        
        let theRegister2 = defaults.array(forKey: "register")
        print(theRegister2!)
        
        //will not check for the 1st time, if last index cooresponding value is 0, invoke logAquiz()
        if rowIndex != 0 {
            var isCallingQuiz:Bool = false
            let lastIntakeIdex=rowIndex-1
            let array:Array<Int> = theRegister2 as! Array<Int>
            let subarray = array[0...lastIntakeIdex]
            for i in subarray{
                if  i == 0 {
                    isCallingQuiz = true
                }
            }
            logAQuiz(areYouSure: isCallingQuiz)
        }
    }
    
    //    1, get @curDate from USUserDefault
    //    2, get todays date
    //    3, compare them, if not equal, reset @curDate and intakeRegister
    func resetByDate(){
        let storedDate = defaults.string(forKey: "currentDate")
        let today:String = dateMana.getCurrentDay()
        let isEqual = (storedDate == today)
        if !isEqual{
            reset()
        }
    }
    
    //reset date/register in NSUserDefaults
    func reset(){
        saveDate()
        resetRegister()
    }
    
    //a register is a list of number that indicate whether user took their drug or not, 1 for Y, 0 for N
    func resetRegister(){
        let intakeRegister:Array<Int> = [0,0,0,0,0]
        defaults.set(intakeRegister, forKey: "register")
    }
    
    //save the current to NSUserDefault
    func saveDate(){
        let date = dateMana.getCurrentDay()
        defaults.set(date, forKey: "currentDate")
    }
    
    //this is where to log a quiz
    func logAQuiz(areYouSure:Bool){
        if areYouSure{
            //call quiz notification here, such as set a quiz 30 min later
            print("user missed last intake, logging a quiz for 5 mins later")
            launchNotification()
        }
    }
    
    func launchNotification(){
        // 1.Create notification content
        let content = UNMutableNotificationContent()
        content.title = "DoseWise: are you feeling well?"
        content.body = "Please answer the quiz to indicate your sobriety"
        
        // 2.Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        
        // 3.Create request identifier
        let requestIdentifier = "simpleNoti"
        
        // 4.Create request
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // 5.Add request to notification center
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
                Const.TIMER_IS_TRIGGERED = true
            }
        }
    }
    
}
