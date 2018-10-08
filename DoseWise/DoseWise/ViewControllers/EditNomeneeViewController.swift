import Foundation
import UIKit

class EditNomeneeViewController : UIViewController{
    
    @IBOutlet weak var nomNameLbl: UITextField!
    @IBOutlet weak var nomPhoneLbl: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var passedNominee = Nominee()
    let dbPresenter = DbPresenter()
    let inputVali = inputValidator()
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        if passedNominee.id != nil {
            nomNameLbl.text = passedNominee.name
            nomPhoneLbl.text = passedNominee.phoneNo
            deleteBtn.isHidden = false
        }
     //   nomNameLbl.setBottomBorder()
     //   nomPhoneLbl.setBottomBorder()
    }
    
    private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissNomineeView(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func deleteNominee(_ sender: Any) {
        dbPresenter.deleteNominee(nominee: passedNominee)
        dismissView()
    }
    
    @IBAction func addOrUpdateNominee(_ sender: Any) {
        let name = nomNameLbl.text!
        let phone = nomPhoneLbl.text!
        if inputVali.validateUserInputNominee(name: name, phone: phone){
            print("TRYING TO ADD NAME \(name) AND PHONE \(phone)")
            if passedNominee.id != nil{
                dbPresenter.updateNominee(nominee: Nominee(id: passedNominee.id!, name: name, phoneNo: phone))
            }else{
                dbPresenter.addNewNominee(nominee: Nominee(id: 0, name: name, phoneNo: phone));
            }
            dismiss(animated: true, completion: nil)
        }
            //Chen's modification
            //adding alert menu when validation failed
        else{
            let alert = UIAlertController(title: "Invalid input", message: "Please type in valid name and phone number, thanks", preferredStyle: .alert)
            
            //            alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil))
            
            self.present(alert, animated: true)
        }
        
    }
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        //self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
