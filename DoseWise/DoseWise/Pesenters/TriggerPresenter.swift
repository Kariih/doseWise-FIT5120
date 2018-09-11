import Foundation

class TriggerPresenter{
    
    init(){
        
    }
    
    let smstrig = SmsTrigger()
    //initialise smsBody
    var smsBody=""
    
    //send sms to nominee when the user failed to answer the quiz correctly
    func executeSMSInUrgent(nominee : [Nominee]){
        //we need to fetch the patient's name and put it below
        let patientName = "John Doe"
        for i in nominee{
            var nomineesName=i.name
            var Body="Hi "+nomineesName!+"! This is DoseWise (a medicine intake management App), Your friend "+patientName+" isn't responding quite well. Could you please check if everything is good?"
            smsBody=Body
            smstrig.SendSms(To: i.phoneNo, Body:smsBody)
        }
    }
    
    //send sms to nominee when they are nominated
    func executeSMSNotInUrgent(nominee:Nominee){
        //we need to fetch the patient's name and put it below
        let patientName = "John Doe"
        var nomineesName=nominee.name
        print("add nominee SMS sent")
        var Body="Hi "+nomineesName!+"! This is DoseWise (a medicine intake management App), Your friend "+patientName+" has nominate you as emergency contact, if you don't know this person please ignore, thanks"
        smsBody=Body
        smstrig.SendSms(To: nominee.phoneNo, Body:smsBody)
    }
}
