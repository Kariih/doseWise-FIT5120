class Schedule{
    
    var id:Int?
    var timing: String!
    var dosage: [String]!
    var medicineName: [String]!
    
    init(id:Int, timing: String, dosage: [String], medicineName: [String]){
        self.id = id
        self.timing = timing
        self.dosage = dosage
        self.medicineName = medicineName
    }
    
    init() {}
}
