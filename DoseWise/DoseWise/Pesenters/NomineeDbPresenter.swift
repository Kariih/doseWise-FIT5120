import Foundation

//presenter class for connecting nominee view and nominee CRUD (model)
class DbPresenter{
    
    let crud = CRUD()
    
    init(){}
    
    //Adding a nominee to database and send a notification to the nominee that the person is added
    func addNewNominee(nominee: Nominee){
        crud.addNominee(nom: nominee)
        sendSMStoNotifyTheNomination(nominee: nominee)
    }
    
    //Fetching the nominees from the table
    func featchAllNominees() -> [Nominee]{
        let list = crud.readNominees()
        Const.nominees = list
        return list
    }
    //update the nominee from database and resend a message to nominee
    func updateNominee(nominee: Nominee) {
        crud.updateNominee(nom: nominee)
        sendSMStoNotifyTheNomination(nominee: nominee)
    }
    //delete the nominee from database
    func deleteNominee(nominee: Nominee){
        crud.deleteNominee(nom: nominee)
    }
    
    //sending SMS to the nominee to let he/she know about the nomination
    func sendSMStoNotifyTheNomination(nominee: Nominee){
        let tPresenter = TriggerPresenter()
        tPresenter.executeSMSNotInUrgent(nominee: nominee)
    }
    
}
