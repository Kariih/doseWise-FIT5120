import UIKit

class TriggerViewController: UIViewController {
    
    @IBOutlet weak var answerTxtLbl: UITextField!
    var tPresenter = TriggerPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func answerTriggerQuestion(_ sender: Any) {
        print("click answer btn")
        print(answerTxtLbl.text!)
        if answerTxtLbl.text! == "6"{
            print("correct")
            dismiss(animated: true, completion: nil)
        }else{
            print("nom count: \(Const.nominees.count)")
            if Const.nominees.count != 0{
                print("SENDING SMS")
              tPresenter.executeSMS(nominee: Const.nominees)
                
                let alert = UIAlertController(title: "We sent SMS to your nominee", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                
                self.present(alert, animated: true)
            }else{
                print("No nominee")
                let alert = UIAlertController(title: "You are not well, you might need to get assistance", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                
                self.present(alert, animated: true)
            }
        }
        Const.TIMER_IS_TRIGGERED = false
    }
}
