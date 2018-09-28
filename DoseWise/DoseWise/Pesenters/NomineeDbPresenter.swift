import Foundation

class DbPresenter{
    
    let crud = CRUD()
    
    init(){}
    
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
