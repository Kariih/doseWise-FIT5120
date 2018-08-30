import Foundation

class DbPresenter{
    
    let crud = CRUD()
    
    init(){}
    
    func validateUserInputNominee(name: String, phone: String) -> Bool{
        return name.isEmpty || phone.isEmpty ? false : true;
    }
    
    func addNewNominee(nominee: Nominee){
        crud.addNominee(nom: nominee)
    }
    
    func featchAllNominees() -> [Nominee]{
        return crud.readNominees()
    }
    func updateNominee(nominee: Nominee) {
        crud.updateNominee(nom: nominee)
    }
    func deleteNominee(nominee: Nominee){
        crud.deleteNominee(nom: nominee)
    }
}
