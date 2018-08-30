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

    @IBAction func dismissNomineeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteNominee(_ sender: Any) {
        
    }
    
    @IBAction func addOrUpdateNominee(_ sender: Any) {
        let name = nomNameLbl.text!
        let phone = nomPhoneLbl.text!
        
        if !passedNominee.name.isEmpty{
            //todo
        }else{
            if dbPresenter.validateUserInputNominee(name: name, phone: phone){
                print("TRYING TO ADD NAME \(name) AND PHONE \(phone)")
                dbPresenter.addNewNominee(nominee: Nominee(id: 1, name: name, phoneNo: phone));
            }
        }
    }
}
