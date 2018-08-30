import UIKit
import UserNotifications

class SchedulerViewController:UIViewController{
    
    var triggerTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        grantNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewDidAppear")
         NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func willEnterForeground() {
        if Const.TIMER_IS_TRIGGERED{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let triggerViewController = storyBoard.instantiateViewController(withIdentifier: "TriggerView") as! TriggerViewController
            self.present(triggerViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func testCase(_ sender: Any) {
        print("prepare to launch notification")
        launchNotification()
    }
    
    private func grantNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if granted {
                // User allow notifications
            }
        }
    }
    func setTrigger(){
        print("setting trigger")
        triggerTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: {_ in
            print("init SMS functionality")
            let tPresenter = TriggerPresenter()
            tPresenter.executeSMS()
            });
    }
    
    func launchNotification(){
        // 1.Create notification content
        let content = UNMutableNotificationContent()
        content.title = "DoseWise: are you feeling well?"
        content.body = "Please answer the quiz to indicate your soberty"
        
        // 2.Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
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
