import Foundation
import UIKit

class EditNomeneeViewController : UIViewController{
    
    @IBOutlet weak var nomNameLbl: UITextField!
    @IBOutlet weak var nomPhoneLbl: UITextField!
    
    var passedNominee = Nominee()
    
    let dbPresenter = DbPresenter();
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        if passedNominee.id != nil {
            nomNameLbl.text = passedNominee.name
            nomPhoneLbl.text = passedNominee.phoneNo
        }
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
        
        if dbPresenter.validateUserInputNominee(name: name, phone: phone){
            print("TRYING TO ADD NAME \(name) AND PHONE \(phone)")
            if passedNominee.id != nil{
                dbPresenter.updateNominee(nominee: Nominee(id: passedNominee.id!, name: name, phoneNo: phone))
            }else{
                dbPresenter.addNewNominee(nominee: Nominee(id: 0, name: name, phoneNo: phone));
            }
            dismiss(animated: true, completion: nil)
        }
    }
}
