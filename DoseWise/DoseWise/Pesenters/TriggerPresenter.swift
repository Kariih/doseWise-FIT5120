import Foundation

class TriggerPresenter{
    
    init(){
        
    }
    
    let smstrig = SmsTrigger()
    //initialise smsBody
    var smsBody=""
    let defaults = UserDefaults.standard
    
    //send sms to nominee when the user failed to answer the quiz correctly
    func executeSMSInUrgent(nominee : [Nominee],currentAddress:String){
        let patientName = defaults.string(forKey: "userName")
        let patientPhoneNo = defaults.string(forKey: "userPhoneNo")
        for i in nominee{
            let nomineesName=i.name
            let Body="Hi "+nomineesName!+"! This is DoseWise (a medicine intake management App), Your friend "+patientName!+" (phone No."+patientPhoneNo!+") isn't responding quite well. Could you please check if everything is good? \n His current location is \n\(currentAddress)"
            smsBody=Body
            smstrig.SendSms(To: i.phoneNo, Body:smsBody)
        }
    }
    
    //send sms to nominee when they are nominated
    func executeSMSNotInUrgent(nominee:Nominee){
        let patientName = defaults.string(forKey: "userName")
        let patientPhoneNo = defaults.string(forKey: "userPhoneNo")
        let nomineesName=nominee.name
        print("add nominee SMS sent")
        let Body="Hi "+nomineesName!+"! This is DoseWise (a medicine intake management App), Your friend "+patientName!+" (phone No."+patientPhoneNo!+") has opted to use DoseWise and nominated you as an emergency contact. Thank you for your help. In case you don’t know this person, please ignore this message. Thank you."
        smsBody=Body
        smstrig.SendSms(To: nominee.phoneNo, Body:smsBody)
    }
}
