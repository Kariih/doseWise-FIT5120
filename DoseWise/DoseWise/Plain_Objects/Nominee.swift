class Nominee {
    
    //Class for making a nominee object
    var id: Int?
    var name: String!
    var phoneNo: String!
    
    init(id: Int, name: String, phoneNo: String){
        self.id = id
        self.name = name
        self.phoneNo = phoneNo
    }
    
    init() {}
}
