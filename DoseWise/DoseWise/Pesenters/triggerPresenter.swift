import Foundation

class triggerPresenter{
    
    var phone : String
    init(phone: String) {
        self.phone = phone
    }
    
    func executeSMS(){
        let smstrig = SmsTrigger()
        smstrig.SendSms(To: self.phone, Body:"Hi there! Your friend isn't responding quite well. Could you please check if everything is good?")
    }
}
