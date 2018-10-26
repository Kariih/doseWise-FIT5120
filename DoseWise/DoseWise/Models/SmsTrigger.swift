import Alamofire

class SmsTrigger {
    var SECRET_KEY:String = "rd3bZdhjP2po0rkiVLhIYv4NFLWyrATh"
    var SECRET_CODE:String = "LvUZzIEAFvadNyuA"
    var ACCESS_TOKEN:String=""
    var TOKEN_TYPE:String=""
    
    static let SharedInstance = SmsTrigger();
    
    init(){}
    
    func SendSms(To:String,Body:String)-> String { //function which sends sms using api
        
        SmsTrigger.SharedInstance.Authenticate(To:To,Body:Body)
        return "completed"    }
    
    //Authenticate call to API
    func Authenticate(To:String, Body: String) -> String {
        
        let Auth_Headers: HTTPHeaders=["CLIENT_KEY":SECRET_KEY,"CLIENT_SECRET":SECRET_CODE]
        let Auth_Parameters: Parameters=["client_id":SECRET_KEY,"client_secret":SECRET_CODE,"grant_type":"client_credentials","scope":"NSMS"]
        Alamofire.request("https://tapi.telstra.com/v2/oauth/token", method: .post, parameters:Auth_Parameters,encoding: URLEncoding.httpBody)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonResponse = response.result.value as! NSDictionary
                    if jsonResponse["access_token"] != nil{
                        let token = jsonResponse["access_token"] as! String
                        let type = jsonResponse["token_type"] as! String
                        SmsTrigger.SharedInstance.Subscribe(Auth: type+" "+token,To:To, Body: Body)
                        print("OAuth Success")
                        
                    }
                case .failure(let error):
                    print("OAuth Failure")
                }
        }
        return self.TOKEN_TYPE+" "+self.ACCESS_TOKEN
    }
    
    // Subscribe call to API
    func Subscribe(Auth: String, To:String, Body: String) -> String {
        
        let Subscribe_headers: HTTPHeaders=["authorization":Auth,"cache-control":"no-cache","content-type":"application/json"]
        let Subscribe_params: Parameters=["activeDays":30]
        Alamofire.request("https://tapi.telstra.com/v2/messages/provisioning/subscriptions", method: .post, parameters:Subscribe_params, encoding: JSONEncoding.default ,headers:Subscribe_headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonResponse = response.result.value as! NSDictionary
                    
                    if jsonResponse["destinationAddress"] != nil{
                        SmsTrigger.SharedInstance.SMS(Auth: Auth, To: To, From: jsonResponse["destinationAddress"] as! String, msg: Body)
                        print("Subscribe Success")
                        
                        print(jsonResponse)
                    }
                    else {
                        
                        print("Subscribe Failure")
                        // print(String: jsonResponse))
                        // print(String(response.request))
                    }
                    
                case .failure(let error):
                    print("Subscribe Failure")
                }
        }
        return "Subscribe Complete"
    }
    
    // Sending SMS 
    func SMS(Auth: String, To:String, From: String, msg:String) -> String {
        
        let Subscribe_headers: HTTPHeaders=["authorization":Auth,"cache-control":"no-cache","content-type":"application/json"]
        let Subscribe_params: Parameters=["to":To,"body":msg]
        Alamofire.request("https://tapi.telstra.com/v2/messages/sms", method: .post, parameters:Subscribe_params, encoding: JSONEncoding.default ,headers:Subscribe_headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonResponse = response.result.value as! NSDictionary
                    
                    if jsonResponse["messageType"] != nil{
                        print("Sms Success")
                        //print(jsonResponse) 
                    }
                    else {
                        
                        print("Sms Failure")
                        // print(String: jsonResponse))
                        // print(String(response.request))
                    }
                    
                case .failure(let error):
                    print("Subscribe Failure")
                }
        }
        return "Subscribe Complete"
    }
}
