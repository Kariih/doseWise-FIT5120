import Foundation
import UIKit

class EditScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var dosageLbl: UILabel!
    @IBOutlet weak var timesLbl: UILabel!
    @IBOutlet weak var medicineNameTxt: UITextField!
    @IBOutlet weak var setTimesLbl: UILabel!
    
    @IBOutlet weak var timeLbl1: UIButton!
    @IBOutlet weak var timeLbl2: UIButton!
    @IBOutlet weak var timeLbl3: UIButton!
    @IBOutlet weak var timeLbl4: UIButton!
    @IBOutlet weak var timeLbl5: UIButton!
    
    var clickedTimedBtn : UIButton!
    
    @IBOutlet weak var timePickerView: UIPickerView!
    var timeLabels : [UIButton] = []
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        timePickerView.delegate = self
        
        timeLabels.append(timeLbl1)
        timeLabels.append(timeLbl2)
        timeLabels.append(timeLbl3)
        timeLabels.append(timeLbl4)
        timeLabels.append(timeLbl5)
        
        timePickerView.backgroundColor = UIColor.white
    }
    
    @IBAction func deleteScheduleAction(_ sender: Any) {
        
    }
    
    @IBAction func daysStepperAction(_ sender: UIStepper) {
        daysLbl.text = String(Int(sender.value))
    }
    
    @IBAction func doseageStepperAction(_ sender: UIStepper) {
        dosageLbl.text = String(Int(sender.value))
    }
    
    @IBAction func timeStepperAction(_ sender: UIStepper) {
        let previousValue = Int(timesLbl.text!)
        let currentValue = Int(sender.value)
        timesLbl.text = String(currentValue)
        
        if currentValue > 0{
            setTimesLbl.isHidden = false
        }
        else{
            setTimesLbl.isHidden = true
        }
        
        if previousValue! > currentValue{
            for i in currentValue...previousValue!-1{
                timeLabels[i].isHidden = true
            }
        }else{
            for i in previousValue!...currentValue-1{
                timeLabels[i].isHidden = false
            }
        }
    }
    
    @IBAction func timeBtnOneClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    @IBAction func timeBtnTwoClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    @IBAction func timeBtnThreeClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    @IBAction func timeBtnFourClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    @IBAction func timeBtnFiveClick(_ sender: UIButton) {
        clickedTimedBtn = sender
        timePickerView.isHidden = false
    }
    
    private func initTimeLabels(times: Int){
        for i in 0...times-1{
           timeLabels[i].isHidden = false
        }
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
        let dbSchedule = CRUDDrugSchedule()
        
        //Add check for nil values here
        let schedule = DrugSchedule(id: 0, name: medicineNameTxt.text!, no_of_days: Int(daysLbl.text!)!, no_of_times_per_day: Int(timesLbl.text!)!, no_of_pills_per_dose: Int(dosageLbl.text!)!, timings: ["11", "12"], type_of_pill: "opioid")
        dbSchedule.addDrugSchedule(DrugSchedule: schedule)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Const.TIMES_A_DAY.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        clickedTimedBtn.setTitle(Const.TIMES_A_DAY[row], for: .normal)
        timePickerView.isHidden = true
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Const.TIMES_A_DAY[row]
    }
}
