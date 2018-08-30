import Foundation

class TriggerPresenter{
    
    var phone : String?
    init(phone: String) {
        self.phone = phone
    }

    init(){}

    func executeSMS(){
        let smstrig = SmsTrigger()
        smstrig.SendSms(To: "+61481080828", Body:"Hi there! Your friend isn't responding quite well. Could you please check if everything is good?")
    }
}
