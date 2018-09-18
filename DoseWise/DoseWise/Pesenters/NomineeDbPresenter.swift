import Foundation

class DbPresenter{
    
    let crud = CRUD()
    
    init(){}
    
    func validateUserInputNominee(name: String, phone: String) -> Bool{
        var isValid = false
        if (name.isEmpty==false) && validatePhoneNo(value: phone) {
            isValid = true
        }
        return isValid
    }
    
    //validate AU phone number
    func validatePhoneNo(value: String) -> Bool {
        let PHONE_REGEX = "^\\({0,1}((0|\\+61)(2|4|3|7|8)){0,1}\\){0,1}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{1}(\\ |-){0,1}[0-9]{3}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        return result
    }
    
    
    func addNewNominee(nominee: Nominee){
        crud.addNominee(nom: nominee)
        sendSMStoNotifyTheNomination(nominee: nominee)
    }
    
    func featchAllNominees() -> [Nominee]{
        let list = crud.readNominees()
        Const.nominees = list
        return list
    }
    func updateNominee(nominee: Nominee) {
        crud.updateNominee(nom: nominee)
        sendSMStoNotifyTheNomination(nominee: nominee)
    }
    func deleteNominee(nominee: Nominee){
        crud.deleteNominee(nom: nominee)
    }
    
    //by Chen, sending SMS to the nominee to let he/she know about the nomination
    func sendSMStoNotifyTheNomination(nominee: Nominee){
        let tPresenter = TriggerPresenter()
        tPresenter.executeSMSNotInUrgent(nominee: nominee)
    }
    
}
