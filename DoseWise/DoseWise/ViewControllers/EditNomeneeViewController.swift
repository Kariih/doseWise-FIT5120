import Foundation
import UIKit

//a view contriller class for CRUD nominee
class EditNomeneeViewController : UIViewController{
    
    @IBOutlet weak var nomNameLbl: UITextField!
    @IBOutlet weak var nomPhoneLbl: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var passedNominee = Nominee()
    let dbPresenter = DbPresenter()
    let inputVali = inputValidator()
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        //Setting nominee details if a nominee is passed
        if passedNominee.id != nil {
            nomNameLbl.text = passedNominee.name
            nomPhoneLbl.text = passedNominee.phoneNo
            deleteBtn.isHidden = false
        }
    }
    //remove view from forground
    private func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    //When clicking button which do not perfrom CRUD
    @IBAction func dismissNomineeView(_ sender: Any) {
        dismissView()
    }
    
    //action connected to the delete bin btn, call nominee CRUD delete funtionality
    @IBAction func deleteNominee(_ sender: Any) {
        dbPresenter.deleteNominee(nominee: passedNominee)
        dismissView()
    }
     //action connected to the save btn, call nominee CRUD add/update funtionality
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
            //dismiss (remove) the view if the update/create is valid
            dismiss(animated: true, completion: nil)
        }

        //adding alert menu when validation failed
        else{
            let alert = UIAlertController(title: "Invalid input", message: "Please type in valid name and phone number, thanks", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil))
            self.present(alert, animated: true)
        }
        
    }
}
