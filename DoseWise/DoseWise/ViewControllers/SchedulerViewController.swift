import UIKit
import UserNotifications
import Foundation
import CoreLocation

var meds=GetMeds.Shared  // please commit
class SchedulerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    @IBOutlet weak var addEditScheduleBtn: UIButton!
    var triggerTimer = Timer()
    var dbDrugSchedule = CRUDDrugSchedule()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var MonthLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.backgroundColor = UIColor.white
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        grantNotification()
        addDateToGUI()
        meds.GlobalInstantiate() // please commit
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Const.dosages = []
        getScheduleFromDb()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        scheduleTableView.reloadData()
        if Const.dosages.count == 0{
            addEditScheduleBtn.setTitle("Add new medicine schedule", for: .normal)
        }
    }
    
    @objc func willEnterForeground() {
        if Const.TIMER_IS_TRIGGERED{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let triggerViewController = storyBoard.instantiateViewController(withIdentifier: "TriggerView") as! TriggerViewController
            self.present(triggerViewController, animated: true, completion: nil)
        }
    }
    
    private func addDateToGUI(){
        let dateManager = DateManager()
        MonthLbl.text = dateManager.getCurrentMonth()
        DayLbl.text = dateManager.getCurrentDay()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(Const.dosages.count)")
        return Const.dosages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        cell.textLabel?.text = "\(Const.dosages[indexPath.item].time) - \(Const.dosages[indexPath.item].dosage) x \(Const.dosages[indexPath.item].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hour = Calendar.current.component(.hour, from: Date())
        print(hour)
        let differenece = Int(Const.TIMES_24_CLOCK[Const.TIMES_A_DAY.index(of: Const.dosages[indexPath.row].time)!])! - hour
        print("differenece \(differenece)")
        if differenece.magnitude <= 1 {
            //tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
            pushReminder()
        }else{
            let title="Wrong schedule"
            let message="The pill isn't consumed according to your schedule, are you sure you will take them now?"
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in
                   /* tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.orange*/
                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            
                self.present(alert,animated:true,completion:nil)
        }
    }
    
    private func getScheduleFromDb(){
        var schedule = dbDrugSchedule.getDrugSchdules()
        if schedule.count > 0{
            Const.currentSchedule = schedule[0]
            for i in 0...schedule[0].no_of_times_per_day-1{
                Const.dosages.append(Pill(name: schedule[0].name, dosage: schedule[0].no_of_pills_per_dose, time: schedule[0].timings[i]))
                print("adding from db")
            }
            scheduleTableView.reloadData()
            addEditScheduleBtn.setTitle("Edit/delete existing schedule", for: .normal)
        }
    }
    
/*    @IBAction func testCase(_ sender: Any) {
        print("prepare to launch notification")
        launchNotification()
    }*/
    
    private func grantNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            if granted {
                // User allow notifications
                
                //get location access
                self.locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager.startUpdatingLocation()
                }
            }
        }
    }
    
    func setTrigger(){
        print("setting trigger")
        triggerTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: {_ in
            print("init SMS functionality")
            let tPresenter = TriggerPresenter()
            // tPresenter.executeSMS()
            
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
    
    //pushReminder start
    //following methods must be put into a view controller
    
    let intakeCounterObj=intakeCounter()

    //this function prompts an alert menu (reminder) that ask user to confirm their intake to the App
    //it takes a schedule object as parameter, and use attributes of the object to populate the alert message
    
    func pushReminder() {
        //get a schedule obj
        var listOfSchedule=CRUDDrugSchedule().getDrugSchdules()
        var firstScheduleObj:DrugSchedule
        firstScheduleObj = listOfSchedule[0]
        
        let drugName = firstScheduleObj.name
        let noOfPillPerDose = String(firstScheduleObj.no_of_pills_per_dose)
        
        let currentCounting=intakeCounterObj.getCounting()

        let theTiming = firstScheduleObj.timings[currentCounting]
        
        let title="Drug intake reminder"
        let message="How much "+drugName!+" have you consumed at "+theTiming+"?"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"Yes, I've taken "+noOfPillPerDose+" pills",style:UIAlertActionStyle.default,handler:{(action:UIAlertAction) in self.chooseSelec(userSelec: "yes")}))
        
        alert.addAction(UIAlertAction(title:"More than "+noOfPillPerDose+" pills",style:UIAlertActionStyle.destructive,handler:{(action:UIAlertAction) in self.chooseSelec(userSelec: "more")}))
        
        alert.addAction(UIAlertAction(title:"Less than "+noOfPillPerDose+" pills",style:UIAlertActionStyle.default,handler:{(action:UIAlertAction) in self.chooseSelec(userSelec: "less")}))
        
        alert.addAction(UIAlertAction(title:"Not going to consume now",style:UIAlertActionStyle.default,handler:{(action:UIAlertAction) in self.chooseSelec(userSelec: "ignore")}))
        
        self.present(alert,animated:true,completion:nil)
    }
    
    //switch cases
    func chooseSelec(userSelec:String){
        let userSelection=userSelec
        switch userSelection {
        case "yes":
            //selectYes()
            break
        case "more":
           // selectMoreQty()
            launchNotification()
            break
        case "less":
           // selectLessQty()
            break
        case "ignore":
          //  selectIgnore()
            break
            
        default:
            print("error at func_deterterminSelec")
        }
    }
    
    func selectYes() {
        intakeCounterObj.confirming(isTaken: true)
        print("yes")
    }
    
    func selectMoreQty() {
        intakeCounterObj.confirming(isTaken: true)
        print("more qty")
    }
    
    func selectLessQty() {
        intakeCounterObj.confirming(isTaken: true)
        print("less qty")
    }
    
    func selectIgnore() {
        intakeCounterObj.confirming(isTaken: false)
        print("Ignore")
    }
    
    //pushReminder ends
    
}

