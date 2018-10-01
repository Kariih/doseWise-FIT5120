import Foundation
import UIKit
import iOSDropDown

class EditScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var timesLbl: UILabel!
    @IBOutlet weak var setTimesLbl: UILabel!
    
    @IBOutlet weak var medicineNameTxt1: DropDown!
    @IBOutlet weak var medicineNameTxt2: DropDown!
    @IBOutlet weak var medicineNameTxt3: DropDown!
    @IBOutlet weak var medicineNameTxt4: DropDown!
    
    @IBOutlet weak var amountLbl1: UITextField!
    @IBOutlet weak var amountLbl2: UITextField!
    @IBOutlet weak var amountLbl3: UITextField!
    @IBOutlet weak var amountLbl4: UITextField!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var timeLbl1: UIButton!
    let dbSchedule = CRUDDrugSchedule()
    @IBOutlet weak var stepperThree: UIStepper!
    
    var clickedTimedBtn : UIButton!
    var numberOfPillsOnSchedule : Int!
    
    @IBOutlet weak var timePickerView: UIPickerView!
    var pillLabels : [(DropDown, UITextField)] = []
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
        
        pillLabels.append((medicineNameTxt1, amountLbl1))
        pillLabels.append((medicineNameTxt2, amountLbl2))
        pillLabels.append((medicineNameTxt3, amountLbl3))
        pillLabels.append((medicineNameTxt4, amountLbl4))
      
        GetMeds.Shared.MED_DATA.sort()
        medicineNameTxt1.optionArray = GetMeds.Shared.MED_DATA
        medicineNameTxt2.optionArray = GetMeds.Shared.MED_DATA
        medicineNameTxt3.optionArray = GetMeds.Shared.MED_DATA
        medicineNameTxt4.optionArray = GetMeds.Shared.MED_DATA// load searchbar
        timePickerView.backgroundColor = UIColor.white
        
        if !Const.currentSchedule.timings.isEmpty{
            deleteBtn.isHidden = false
            setDataForEdit()
        }
    }
    
    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if medicineNameTxt1.optionArray[0] == ""{
            EmptyMedlistpopup()
        }
    }
    
    private func setDataForEdit(){
        let drug = Const.currentSchedule
        timesLbl.text = String(drug.no_of_times_per_day)
        stepperThree.value = Double(drug.no_of_times_per_day)
        numberOfPillsOnSchedule = drug.no_of_times_per_day
        medicineNameTxt1.text = drug.name
        
        for i in 0...drug.no_of_times_per_day-1{
         //   pillLabels[i].setTitle(drug.timings[i], for: .normal)
            pillLabels[i].1.isHidden = false
            pillLabels[i].0.isHidden = false
        }
    }
    
    @IBAction func deleteScheduleAction(_ sender: Any) {
        dbSchedule.deleteAllDrugSchedule()
        Const.dosages = []
        Const.currentSchedule = DrugSchedule()
        dismissView()
    }

    @IBAction func pillAmountStepperAction(_ sender: UIStepper) {
        let previousValue = Int(timesLbl.text!)
        let currentValue = Int(sender.value)
        numberOfPillsOnSchedule = currentValue
        timesLbl.text = String(currentValue)
        
        if currentValue > 0{
            setTimesLbl.isHidden = false
        }
        else{
            setTimesLbl.isHidden = true
        }
        
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
    
    @IBAction func timeBtnOneClick(_ sender: UIButton) {
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
    
    @IBAction func saveBtnClick(_ sender: Any) {
        var timings: [String] = []
        if numberOfPillsOnSchedule != nil{
            let notificationManager = NotificationReminderManager()
            notificationManager.addReminder(time: "1pm")
            for i in 0...numberOfPillsOnSchedule-1{
             //   timings.append(pillLabels[i].title(for: .normal)!)
            }
            //Add check for nil values here
       //     let schedule = DrugSchedule(id: 0, name: medicineNameTxt1.text!, no_of_days: Int(daysLbl.text!)!, no_of_times_per_day: Int(timesLbl.text!)!, no_of_pills_per_dose: Int(dosageLbl.text!)!, timings: timings, type_of_pill: "opioid")
            dbSchedule.deleteAllDrugSchedule()
         //   dbSchedule.addDrugSchedule(DrugSchedule: schedule)
        }
        dismissView()
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
        timePickerView.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Const.TIMES_A_DAY[component][row]
    }
    
    func EmptyMedlistpopup() {

        
        let alert = UIAlertController(title: "No Internet connection",message: "Unable to retrieve data from server. Please type in the medicine name manually",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
       
        
        self.present(alert, animated: true)
       
    }
}
