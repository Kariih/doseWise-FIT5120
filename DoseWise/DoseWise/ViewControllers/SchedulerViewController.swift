import UIKit
import UserNotifications
import Foundation
import CoreLocation

class SchedulerViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    var triggerTimer = Timer()
    var dbDrugSchedule = ScheduleCRUD()
    let locationManager = CLLocationManager()
    let intakeCounterObj=intakeCounter()
    
    private var passingSchedule = Schedule()
    
    private var scheduleList = [Schedule]()
    
    @IBOutlet weak var MonthLbl: UILabel!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var addScheduleButton: UIButton!
    
    private var clickedIndexes = [0,0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.backgroundColor = UIColor.white
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        //aks for permission to access notifications and location
        grantNotification()
        addDateToGUI()
        intakeCounterObj.resetByDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openFirstTimeLauchTC()
        getScheduleFromDb()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        scheduleTableView.reloadData()
        disableAddScheBtn()
    }
    
    //fetching schedules from db if someone exist
    private func getScheduleFromDb(){
        scheduleList = dbDrugSchedule.getSchedules()
        scheduleTableView.reloadData()
    }
    //open the trigger view next time app is brought to foreground
    @objc func willEnterForeground() {
        if Const.TIMER_IS_TRIGGERED{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let triggerViewController = storyBoard.instantiateViewController(withIdentifier: "TriggerView") as! TriggerViewController
            self.present(triggerViewController, animated: true, completion: nil)
        }
    }
    //lauch terms and condtions if the app is open for the first time.
    private func openFirstTimeLauchTC(){
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppLaunched") == nil{
            defaults.set(true, forKey: "isAppLaunched")
            self.performSegue(withIdentifier: "tcSegue", sender: self)
        }
    }
    //adding the date to the front page
    private func addDateToGUI(){
        let dateManager = DateManager()
        MonthLbl.text = dateManager.getCurrentMonthTxt()
        DayLbl.text = dateManager.getCurrentDay()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(scheduleList.count)")
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //adding the medicine data to the tableview cell
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        var detail = ""
        let numOfMedicines = scheduleList[indexPath.item].medicineName.count-1;
        for i in 0...numOfMedicines{
            detail.append("\(scheduleList[indexPath.item].medicineName[i]) -\(scheduleList[indexPath.item].dosage[i]) pill(s) \n")
        }
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = "\(scheduleList[indexPath.item].timing!)"
        cell.detailTextLabel?.text = "\(detail)"
        
        //adding color if a row of medicine is taken, and disable click
        if clickedIndexes[indexPath.row] == 1{
            cell.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
            cell.isUserInteractionEnabled = false;
        }else if clickedIndexes[indexPath.row] == 2{
            cell.backgroundColor = UIColor(red:1.00, green:0.90, blue:0.90, alpha:1.0)
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //functionality for when a cell is clicked.
        //First check if the pill is taking withing resonable time of the shedule
        let hour = Calendar.current.component(.hour, from: Date())
        //parse current timing into hour
        let currentTiming:String = scheduleList[indexPath.row].timing
        let currentHour:String = currentTiming.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let differenece = Int(currentHour)! - hour
        print("differenece \(differenece)")
        if differenece.magnitude <= 1 {
            pushReminder(rowIndex: indexPath.row)
        }else{
            //notify is the schedule is wrong
            let title="Wrong schedule"
            let message="The pill isn't consumed according to your schedule, it is highly recommended that not to consume your drug outside of scheduled time"
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,animated:true,completion:nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //adding the edit to table view
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            Const.clickedSchedule = indexPath[1]
            self.performSegue(withIdentifier: "scheduleEditSegue", sender: self)
        }
        edit.backgroundColor = .orange
        passingSchedule = scheduleList[indexPath.row]
        return [edit]
    }
    
    //ask for notification access permission.
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

    //push notification outside the application.
    func launchNotification(){
        // 1.Create notification content
        let content = UNMutableNotificationContent()
        content.title = "DoseWise: are you feeling well?"
        content.body = "Please answer the quiz to indicate your sobriety"
        
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
    
    //push alert menu for user to select their intake status.
    func pushReminder(rowIndex:Int) {
        //get a schedule obj
        
        let drugName = scheduleList[rowIndex].medicineName.joined(separator: ", ")
        var pills = 0
        scheduleList[rowIndex].dosage.forEach{dose in pills += Int(dose)!}
        let noOfPillPerDose = String(pills)
        
        let theTiming = scheduleList[rowIndex].timing
        
        let title="Drug intake reminder"
        let message="How much "+drugName+" have you consumed at "+theTiming!+"?"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"Yes, I've taken "+noOfPillPerDose+" pills",style:UIAlertActionStyle.default,handler:{(action:UIAlertAction) in
            self.addColorForRow(index: rowIndex, colorType: 1)
            self.chooseSelec(userSelec: "yes", rowIndex: rowIndex)}))
        
        alert.addAction(UIAlertAction(title:"More than "+noOfPillPerDose+" pills",style:UIAlertActionStyle.destructive,handler:{(action:UIAlertAction) in
            self.addColorForRow(index: rowIndex, colorType: 2)
            self.chooseSelec(userSelec: "more", rowIndex: rowIndex)}))
        
        alert.addAction(UIAlertAction(title:"Less than "+noOfPillPerDose+" pills",style:UIAlertActionStyle.default,handler:{(action:UIAlertAction) in
            self.addColorForRow(index: rowIndex, colorType: 1)
            self.chooseSelec(userSelec: "less", rowIndex: rowIndex)}))
        
        alert.addAction(UIAlertAction(title:"Not going to consume now",style:UIAlertActionStyle.default,handler:{(action:UIAlertAction) in self.chooseSelec(userSelec: "ignore", rowIndex: rowIndex)}))
        
        self.present(alert,animated:true,completion:nil)
    }
    
    //change the color of a row (taken schedule), call the save rows funtions and reload the tableView with new colors 
    private func addColorForRow(index: Int, colorType: Int){
        clickedIndexes[index] = colorType
        saveClickedToDefaults()
        scheduleTableView.reloadData()
    }
    
    //switch cases
    func chooseSelec(userSelec:String, rowIndex:Int){
        let userSelection=userSelec
        switch userSelection {
        case "yes":
            selectYes(rowIndex: rowIndex)
            break
        case "more":
            selectMoreQty(rowIndex: rowIndex)
            intakeCounterObj.launchNotification()
            break
        case "less":
            selectLessQty(rowIndex: rowIndex)
            break
        case "ignore":
            selectIgnore(rowIndex: rowIndex)
            break
        default:
            print("error at func_deterterminSelec")
        }
    }
    
    //the following select methods are using to registration of counter.
    func selectYes(rowIndex:Int) {
        intakeCounterObj.confirming(isTaken: true, rowIndex: rowIndex)
        print("yes")
    }
    
    func selectMoreQty(rowIndex:Int) {
        intakeCounterObj.confirming(isTaken: true, rowIndex: rowIndex)
        print("more qty")
    }
    
    func selectLessQty(rowIndex:Int) {
        intakeCounterObj.confirming(isTaken: true, rowIndex: rowIndex)
        print("less qty")
    }
    
    func selectIgnore(rowIndex:Int) {
        intakeCounterObj.confirming(isTaken: false, rowIndex: rowIndex)
        print("Ignore")
    }
    
    //disabled the add schedule button after there are 5 schedules in the view
    func disableAddScheBtn(){
        if scheduleList.count<=4{
            addScheduleButton.isEnabled=true;
            addScheduleButton.alpha = 1.0;
        }else{
            addScheduleButton.isEnabled=false;
            addScheduleButton.alpha = 0.5;
        }
    }
    
    @IBAction func addScheBtn(_ sender: Any) {
        addSchedule()
    }
    //open the edit schedule view programtically
    func addSchedule(){
        passingSchedule = Schedule()
        performSegue(withIdentifier: "scheduleEditSegue", sender: self)
    }
    // adding a schedule to the segue if a schedule cell is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scheduleEditSegue" {
            let viewController = segue.destination as! EditScheduleViewController
            viewController.passedSchedule = passingSchedule
        }
    }
    //dave the color coded (taken schedules) rows to default
    func saveClickedToDefaults(){
        UserDefaults.standard.set(clickedIndexes, forKey: "clickedIndexes")
    }
    //get the color coded (taken schedules) rows from default
    func retireveClickedFromDefaults()->[Int]{
        return UserDefaults.standard.array(forKey: "clickedIndexes") as! [Int]
    }
}
