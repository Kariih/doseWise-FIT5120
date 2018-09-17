import UIKit
import UserNotifications

class SchedulerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var addEditScheduleBtn: UIButton!
    var triggerTimer = Timer()
    var dbDrugSchedule = CRUDDrugSchedule()
    
    @IBOutlet weak var MonthLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        grantNotification()
        addDateToGUI()
        
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
    print("returning cell")
        return cell
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
        
        var drugName = firstScheduleObj.name
        var noOfPillPerDose = String(firstScheduleObj.no_of_pills_per_dose)
        
        var currentCounting=intakeCounterObj.getCounting()

        var theTiming = firstScheduleObj.timings[currentCounting]
        
        var title="Drug intake reminder"
        var message="How much "+drugName!+" have you consumed at "+theTiming+"?"
        
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
            selectYes()
        case "more":
            selectMoreQty()
        case "less":
            selectLessQty()
        case "ignore":
            selectIgnore()
            
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

