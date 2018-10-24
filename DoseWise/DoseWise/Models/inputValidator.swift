import Foundation

//call this class when validating name & phone number
class inputValidator{
    
    init() {
        
    }
    
    //validate nominee entry
    func validateUserInputNominee(name: String, phone: String) -> Bool{
        var isValid = false
        if validateName(name: name) && validatePhoneNo(phoneNo: phone) {
            isValid = true
        }
        return isValid
    }
    
    //name only accept aphabets and blanks
    func validateName(name:String)->Bool{
        var isValid = false
        let regex = try? NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
        if regex?.firstMatch(in: name, options: [], range: NSMakeRange(0, name.characters.count)) != nil {
            isValid = false
        } else {
            isValid = true
        }
        return isValid
    }
    
    //phoneNo only accept AU phone number
    func validatePhoneNo(phoneNo: String) -> Bool {
        let PHONE_REGEX = "^\\({0,1}((0|\\+61)(2|4|3|7|8)){0,1}\\){0,1}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{1}(\\ |-){0,1}[0-9]{3}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phoneNo)
        return result
    }
    
    //validate pill number, only acccept 1-9
    func validatePillNumber(pillNo:String) -> Bool{
        let PILL_REGEX = "\\b\\d\\b"
        let pillTest = NSPredicate(format: "SELF MATCHES %@", PILL_REGEX)
        let result = pillTest.evaluate(with:pillNo)
        return result
    }
}
