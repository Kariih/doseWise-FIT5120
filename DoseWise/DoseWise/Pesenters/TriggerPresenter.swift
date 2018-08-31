import Foundation

class TriggerPresenter{
    
    init(){}

    func executeSMS(nominee : [Nominee]){
        let smstrig = SmsTrigger()
        
        nominee.forEach { (Nominee) in
            smstrig.SendSms(To: Nominee.phoneNo, Body:"Hi there! Your friend isn't responding quite well. Could you please check if everything is good?")
        }
    }
}
