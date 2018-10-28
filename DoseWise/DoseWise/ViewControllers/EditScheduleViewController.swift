import Foundation
import UIKit
import iOSDropDown

class EditScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var timesLbl: UILabel!
    @IBOutlet weak var medicineNameTxt1: DropDown!
    @IBOutlet weak var medicineNameTxt2: DropDown!
    @IBOutlet weak var medicineNameTxt3: DropDown!
    @IBOutlet weak var medicineNameTxt4: DropDown!
    @IBOutlet weak var amountLbl1: UITextField!
    @IBOutlet weak var amountLbl2: UITextField!
    @IBOutlet weak var amountLbl3: UITextField!
    @IBOutlet weak var amountLbl4: UITextField!
    @IBOutlet weak var medicineNumberStepper: UIStepper!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var setTimeForScheduleLbl: UIButton!
    
    let dbSchedule = ScheduleCRUD()
    var notificationManager:NotificationReminderManager!
    let inputVali = inputValidator()
    var passedSchedule = Schedule()
    var clickedTimedBtn : UIButton!
    var numberOfMedicineOnSchedule : Int!
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
        notificationManager = NotificationReminderManager()
        
        pillLabels.append((medicineNameTxt1, amountLbl1))
        pillLabels.append((medicineNameTxt2, amountLbl2))
        pillLabels.append((medicineNameTxt3, amountLbl3))
        pillLabels.append((medicineNameTxt4, amountLbl4))
        
        //Get meds if not loaded form server
        GetMeds.Shared.MED_DATA.sort()
        
        
        let length = pillLabels.count-1
        //adding the dropdown with pill names to pill dropdown label
        for i in 0...length{
            pillLabels[i].0.optionArray = GetMeds.Shared.MED_DATA
            self.view.bringSubview(toFront: pillLabels[length-i].0)
        }
        timePickerView.backgroundColor = UIColor.white
        
        //check the id for schedule which is clicked. -1 mean no schedule cliked
        if Const.clickedSchedule != -1{
            deleteBtn.isHidden = false
            setDataForEdit()
        }
        self.hideKeyboardOrPickerWhenTappedAround()
    }
    // add action to pickerView wich setting time
    @IBOutlet weak var timePickerView: UIPickerView!
    var pillLabels : [(DropDown, UITextField)] = []
    
    //hide the picker view/keyboard for time of the click is outside the picker view/keyboard
    func hideKeyboardOrPickerWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditScheduleViewController.dismissKeyboardOrPicker))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
 
    @objc func dismissKeyboardOrPicker() {
        view.endEditing(true)
        timePickerView.isHidden = true
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setting the dropdown labels to empty list is if the meds array isnt loaded
        for i in 0...pillLabels.count-1{
            if pillLabels[i].0.optionArray[0] == ""{
                EmptyMedlistpopup()
            }
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        //reset the clicked id when user exit the view
        Const.clickedSchedule = -1
    }
    
    //if user update schedule, the schedule details are set to the labels
    private func setDataForEdit(){
        //        let dose = Const.dosages[Const.clickedSchedule]
        let dose = passedSchedule
        setTimeForScheduleLbl.setTitle(dose.timing, for: .normal)
        timesLbl.text = String(dose.dosage.count)
        medicineNumberStepper.value = Double(dose.dosage.count)
        for i in 0...dose.dosage.count-1{
            let label = pillLabels[i]
            label.0.text = dose.medicineName[i]
            label.1.text = dose.dosage[i]
            label.1.isHidden = false
            label.0.isHidden = false
        }
    }
    
    //action when click call the delete in the schduele CRUD class and remove reminder for the schedule
    @IBAction func deleteScheduleAction(_ sender: Any) {
        notificationManager.removeReminder(time:passedSchedule.timing)
        dbSchedule.deleteDrugSchedule(sche: passedSchedule)
        dismissView()
    }
    //adding the stepper which give user access to add medicines in the schedule
    @IBAction func addMedicineStepperAction(_ sender: UIStepper) {
        let previousValue = Int(timesLbl.text!)
        let currentValue = Int(sender.value)
        numberOfMedicineOnSchedule = currentValue
        timesLbl.text = String(currentValue)
        print("STEPPER VALUE \(sender.value)")
        
        if previousValue! > currentValue{
            for i in currentValue...previousValue!-1{
                pillLabels[i].0.isHidden = true
                pillLabels[i].1.isHidden = true
            }
        }else{
            for i in previousValue!...currentValue-1{
                pillLabels[i].0.isHidden = false
                pillLabels[i].1.isHidden = false
            }
        }
    }
    //Open the picker when the user want to set the time for schedule
    @IBAction func timeBtnOnClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    //remove view if cancel is clicked
    @IBAction func cancelBtnClick(_ sender: Any) {
        dismissView()
    }
    //remove view if back is clicked
    @IBAction func backBtnClick(_ sender: Any) {
        dismissView()
    }
    //remove view from foreground
    private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    //ckeck that all information is present and then add or update a schedule
    func addOrUpdateSchedule(){
        var medicines: [String] = []
        var dosage: [String] = []
        if let medicinesOnSchedule = Int(timesLbl.text!){
            for i in 0...medicinesOnSchedule-1{
                medicines.append(pillLabels[i].0.text!)
                dosage.append(pillLabels[i].1.text!)
            }
        }
        let time = setTimeForScheduleLbl.title(for: .normal)!
        
        if validateScheduleInput(time: time, medicines: medicines, dosage: dosage){
            var aSchedule:Schedule = Schedule()
            if passedSchedule.id != nil{
                aSchedule = Schedule(id:passedSchedule.id!,timing: time,dosage:dosage,medicineName:medicines)
                dbSchedule.updateSchedule(sche: aSchedule)
                print("update schedule\(aSchedule.medicineName!)")
            }else{
                aSchedule = Schedule(id:0,timing: time,dosage:dosage,medicineName:medicines)
                dbSchedule.addSchedule(schedule: aSchedule)
                print("add new schedule\(aSchedule.medicineName!)")
            }
            Const.clickedSchedule = -1
            notificationManager.addReminder(time: aSchedule.timing)
            dismissView()
        }else{
            print("addOrUpdateSchedule failed, for validation not passed")
        }
    }
    //action for saving schedule, call the addOrUpdateSchedule function
    @IBAction func saveBtnClick(_ sender: Any) {
        addOrUpdateSchedule()
    }
    
    //validate every inputs of the view
    func validateScheduleInput(time:String,medicines:[String],dosage:[String])->Bool{
        var isValid = true
        if time != "Click here to set time"{
            //do nothing, continue
        }else{
            isValid = false
            cantAddScheduleAlert(message: "No time is set for schedule")
        }
        for i in dosage{
            if inputVali.validatePillNumber(pillNo: i) && i != "0"{
                //everything good, do nothing
            }else{
                isValid = false
                cantAddScheduleAlert(message: "Please enter the valid number of pills, between 1 - 9")
            }
        }
        for i in medicines{
            if !i.isEmpty && i.count>=2 {
                //do nothing, continue
            }else{
                isValid = false
                cantAddScheduleAlert(message: "Please enter valid drug names")
            }
        }
        return isValid
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Const.TIMES_A_DAY.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Const.TIMES_A_DAY[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //add details for every row in the picker view
        let hour = Const.TIMES_A_DAY[0][pickerView.selectedRow(inComponent: 0)]
        let minute = Const.TIMES_A_DAY[1][pickerView.selectedRow(inComponent: 1)]
        let theTiming:String = hour + ":" + minute
        clickedTimedBtn.setTitle(theTiming, for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Const.TIMES_A_DAY[component][row]
    }
    
    //Return error message if server call failed. 
    func EmptyMedlistpopup() {
        let alert = UIAlertController(title: "No Internet connection",message: "Unable to retrieve data from server. Please type in the medicine name manually",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    //alert added if the schedule cant be succesfully added
    func cantAddScheduleAlert(message: String){
        let alert = UIAlertController(title: "Can't add Schedule", message:message ,preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
}
