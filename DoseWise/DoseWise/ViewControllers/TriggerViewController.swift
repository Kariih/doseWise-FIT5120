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
            print("SENDING SMS")
            tPresenter.executeSMS()
            let alert = UIAlertController(title: "We sent SMS to your nominee", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
