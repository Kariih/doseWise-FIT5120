import Foundation
import UIKit

class EditNomeneeViewController : UIViewController{
    
    @IBOutlet weak var nomNameLbl: UITextField!
    @IBOutlet weak var nomPhoneLbl: UITextField!
    
    let dbPresenter = DbPresenter();
    
    override func viewDidLoad(){
        super.viewDidLoad();
    }

    @IBAction func dismissNomineeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteNominee(_ sender: Any) {
        
    }
    
    @IBAction func addOrUpdateNominee(_ sender: Any) {
        let name = nomNameLbl.text!
        let phone = nomNameLbl.text!
        if dbPresenter.validateUserInputNominee(name: name, phone: phone){
            dbPresenter.addNewNominee(nominee: Nominee(id: 1, name: name, phoneNo: phone));
        }
    }
}
