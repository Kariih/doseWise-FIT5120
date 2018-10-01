import Foundation
import Alamofire
class GetMeds{
    
    var MEDSEARCH_COMPLETE:Bool = false
    var MEDSEARCH: [String]=[""]
    var MED_DATA:[String]=[""]
    static let Shared = GetMeds()
    
    private init() {
        GetServerData { (response) in
            self.MED_DATA=response
        }
    }
    
    public func GlobalInstantiate()->GetMeds{
        return self
    }
    func GetServerData(completion: @escaping ([String])-> Void){
        let todoEndpoint: String = "https://dosewise-server.herokuapp.com/res/api/dataRequest"
        var meds:[String]=[""]
        
        Alamofire.request(todoEndpoint)
            .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let jsonResponse = response.result.value as! NSArray
                    meds=jsonResponse.value(forKey: "name") as! [String]
                    print("Server Success")
                    completion(meds)
                //
                case .failure(let error):
                    print("Server Failure")
                }
        }
    }
    
    func searchmeds(searchstring: String,searchcompletion: @escaping ([String])-> Void){
        var searchResult=[""]
        
        searchResult = MED_DATA.filter{$0.contains(searchstring)}
        self.MEDSEARCH=searchResult
        
        searchcompletion(searchResult)
    }
}
