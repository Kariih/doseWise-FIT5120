import Foundation
import UIKit

class EditScheduleViewController: UIViewController{
    
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var dosageLbl: UILabel!
    @IBOutlet weak var timesLbl: UILabel!
    @IBOutlet weak var medicineNameTxt: UITextField!
    @IBOutlet weak var setTimesLbl: UILabel!
    
    @IBOutlet weak var timeLbl1: UILabel!
    @IBOutlet weak var timeLbl2: UILabel!
    @IBOutlet weak var timeLbl3: UILabel!
    @IBOutlet weak var timeLbl4: UILabel!
    @IBOutlet weak var timeLbl5: UILabel!
    
    var timeLabels : [UILabel] = []
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabels.append(timeLbl1)
        timeLabels.append(timeLbl2)
        timeLabels.append(timeLbl3)
        timeLabels.append(timeLbl4)
        timeLabels.append(timeLbl5)
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
        let previousValue = Int(setTimesLbl.text!)
        let currentValue = Int(sender.value)
        timesLbl.text = String(currentValue)
        
        if previousValue! > currentValue{
            for i in currentValue...previousValue!{
                timeLabels[i].isHidden = true
            }
        }else{
            for i in previousValue!...currentValue{
                timeLabels[i].isHidden = false
            }
        }
        
        
        if Int(sender.value) > 0{
            initTimeLabels(times: Int(sender.value))
        }else{
          //  HIDE
        }
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
}
