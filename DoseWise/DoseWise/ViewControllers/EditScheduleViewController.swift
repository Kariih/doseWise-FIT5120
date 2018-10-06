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
    var clickedTimedBtn : UIButton!
    var numberOfMedicineOnSchedule : Int!
    
    @IBOutlet weak var timePickerView: UIPickerView!
    var pillLabels : [(DropDown, UITextField)] = []
    
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
        
        GetMeds.Shared.MED_DATA.sort()
        
        let length = pillLabels.count-1
        for i in 0...length{
            pillLabels[i].0.optionArray = GetMeds.Shared.MED_DATA
            self.view.bringSubview(toFront: pillLabels[length-i].0)
        }
        timePickerView.backgroundColor = UIColor.white
        
        if Const.clickedSchedule != -1{
            deleteBtn.isHidden = false
            setDataForEdit()
        }
        self.hideKeyboardOrPickerWhenTappedAround()
    }
    
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
        for i in 0...pillLabels.count-1{
            if pillLabels[i].0.optionArray[0] == ""{
                EmptyMedlistpopup()
            }
        }
    }
    
    override
    func viewWillDisappear(_ animated: Bool) {
        Const.clickedSchedule = -1
    }
    
    private func setDataForEdit(){
        let dose = Const.dosages[Const.clickedSchedule]
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
    
    @IBAction func deleteScheduleAction(_ sender: Any) {
        notificationManager.removeReminder(time:Const.dosages[Const.clickedSchedule].timing)
        dbSchedule.deleteDrugSchedule(id: Const.clickedSchedule+1)
        Const.dosages.remove(at: Const.clickedSchedule)
        Const.clickedSchedule = -1
        dismissView()
    }
    
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
    
    @IBAction func timeBtnOnClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        dismissView()
    }
    
    private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    //    @IBAction func saveBtnClick(_ sender: Any) {
    //        var medicines: [String] = []
    //        var dosage: [String] = []
    //        let id = Const.clickedSchedule != -1 ? Const.clickedSchedule+1 : dbSchedule.getRows()+1
    //        if Const.clickedSchedule != -1 {
    //            dbSchedule.deleteDrugSchedule(id: id)
    //        }
    //        if let medicinesOnSchedule = Int(timesLbl.text!){
    //            for i in 0...medicinesOnSchedule-1{
    //                medicines.append(pillLabels[i].0.text!)
    //                dosage.append(pillLabels[i].1.text!)
    //            }
    //        }
    //        let time = setTimeForScheduleLbl.title(for: .normal)!
    //        if time != "Click here to set time"{
    //            if id > 5{
    //                cantAddScheduleAlert(message: "You are trying to add too many schedules")
    //                return
    //            }
    //            let schedule = Schedule(timing: setTimeForScheduleLbl.title(for: .normal)!, dosage: dosage, medicineName: medicines)
    //            dbSchedule.addSchedule(schedule: schedule, id: id)
    //            Const.clickedSchedule = -1
    //            notificationManager.addReminder(time: schedule.timing)
    //            dismissView()
    //        }else{
    //            cantAddScheduleAlert(message: "No time is set for schedule")
    //        }
    //    }
    
    //    @IBAction func saveBtnClick(_ sender: Any) {
    //        var medicines: [String] = []
    //        var dosage: [String] = []
    //        let id = Const.clickedSchedule != -1 ? Const.clickedSchedule+1 : dbSchedule.getRows()+1
    //        if Const.clickedSchedule != -1 {
    //            dbSchedule.deleteDrugSchedule(id: id)
    //        }
    //        if let medicinesOnSchedule = Int(timesLbl.text!){
    //            for i in 0...medicinesOnSchedule-1{
    //                medicines.append(pillLabels[i].0.text!)
    //                dosage.append(pillLabels[i].1.text!)
    //            }
    //        }
    //        let time = setTimeForScheduleLbl.title(for: .normal)!
    //        if time != "Click here to set time"{
    //            if id > 5{
    //                cantAddScheduleAlert(message: "You are trying to add too many schedules")
    //                return
    //            }
    //            var allDrugNameValid:Bool = true
    //            for i in medicines{
    //
    //                if !i.isEmpty && i.count>=2 {
    //                    //everything good, do nothing
    //                }else{
    //                    allDrugNameValid = false
    //                }
    //            }
    //            if allDrugNameValid {
    //                let schedule = Schedule(timing: setTimeForScheduleLbl.title(for: .normal)!, dosage: dosage, medicineName: medicines)
    //                dbSchedule.addSchedule(schedule: schedule, id: id)
    //                Const.clickedSchedule = -1
    //                notificationManager.addReminder(time: schedule.timing)
    //                dismissView()
    //            }else{
    //                cantAddScheduleAlert(message: "Please enter the drug name")
    //            }
    //        }else{
    //            cantAddScheduleAlert(message: "No time is set for schedule")
    //        }
    //    }
    
    @IBAction func saveBtnClick(_ sender: Any) {
        var medicines: [String] = []
        var dosage: [String] = []
        let id = Const.clickedSchedule != -1 ? Const.clickedSchedule+1 : dbSchedule.getRows()+1
        if Const.clickedSchedule != -1 {
            dbSchedule.deleteDrugSchedule(id: id)
        }
        if let medicinesOnSchedule = Int(timesLbl.text!){
            for i in 0...medicinesOnSchedule-1{
                medicines.append(pillLabels[i].0.text!)
                dosage.append(pillLabels[i].1.text!)
            }
        }
        let time = setTimeForScheduleLbl.title(for: .normal)!
        if time != "Click here to set time"{
            if id > 5{
                cantAddScheduleAlert(message: "You are trying to add too many schedules")
                return
            }
            var allDrugNameValid:Bool = true
            for i in medicines{
                
                if !i.isEmpty && i.count>=2 {
                    //everything good, do nothing
                }else{
                    allDrugNameValid = false
                }
            }
            if allDrugNameValid {
                var allDosageValid:Bool = true
                for i in dosage{
                    if inputVali.validatePillNumber(pillNo: i) && i != "0"{
                        //everything good, do nothing
                    }else{
                        allDosageValid = false
                    }
                }
                if allDosageValid{
                    let schedule = Schedule(timing: setTimeForScheduleLbl.title(for: .normal)!, dosage: dosage, medicineName: medicines)
                    dbSchedule.addSchedule(schedule: schedule, id: id)
                    Const.clickedSchedule = -1
                    notificationManager.addReminder(time: schedule.timing)
                    dismissView()
                }else{
                    cantAddScheduleAlert(message: "Please enter the valid number of pills")
                }
            }else{
                cantAddScheduleAlert(message: "Please enter valid drug names")
            }
        }else{
            cantAddScheduleAlert(message: "No time is set for schedule")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Const.TIMES_A_DAY.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Const.TIMES_A_DAY[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hour = Const.TIMES_A_DAY[0][pickerView.selectedRow(inComponent: 0)]
        let minute = Const.TIMES_A_DAY[1][pickerView.selectedRow(inComponent: 1)]
        let theTiming:String = hour + ":" + minute
        clickedTimedBtn.setTitle(theTiming, for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Const.TIMES_A_DAY[component][row]
    }
    
    func EmptyMedlistpopup() {
        let alert = UIAlertController(title: "No Internet connection",message: "Unable to retrieve data from server. Please type in the medicine name manually",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func cantAddScheduleAlert(message: String){
        let alert = UIAlertController(title: "Can't add Schedule", message:message ,preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true,completion: nil)
    }
}
