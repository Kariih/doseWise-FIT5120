import UIKit
import CoreLocation

class TriggerViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var answerTxtLbl: UITextField!
    @IBOutlet weak var questionLbl: UILabel!
    var tPresenter = TriggerPresenter()
    let locationManager = CLLocationManager()
    var addressLocation="";
    var quiz = Quiz()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //can be used when the app is open and runs in background
        //locationManager.requestAlwaysAuthorization()
        
        //to be used only when the app is open
       locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        quiz.createQuizzes()
        questionLbl.text = quiz.ranSeleQue()
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
           // var loc:CLLocation=CLLocation(latitude: -37.8678816, longitude: 144.9891866) // replace this for custom address
            CLGeocoder().reverseGeocodeLocation(location){(placemark,error) in
             if error != nil
             {
                print("Geocoder Error")
                }
                
             else{
                if let place = placemark?[0]
                {
                    self.addressLocation=self.displayLocationInfo(placemark: place)
                    print(self.addressLocation)
                }
                
                }
            }
    }
    }
    func displayLocationInfo(placemark: CLPlacemark?) -> String
    {
        if let containsPlacemark = placemark
        {
            var result=""
            let subThro=(containsPlacemark.subThoroughfare != nil) ? containsPlacemark.subThoroughfare : ""
            let thro=(containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
            let sublocality=(containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality : ""
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            result = "\(String(describing: subThro!)) \(String(describing: thro!)) \(String(describing: sublocality!)) \(String(describing: locality!)) \(String(describing: postalCode!)) \(String(describing: administrativeArea!)) \(String(describing: country!))"
           
            return result
            
        } else {
            
            return ""
            
        }
        
    }
    // If we have been denied access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been denied access
    func showLocationDisabledPopUp() {
        let locationAlertController = UIAlertController(title: "Background Location Access Disabled",
                                                        message: "In order to message your nomineee, we need your location",
                                                        preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        locationAlertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        locationAlertController.addAction(openAction)
        
        self.present(locationAlertController, animated: true, completion: nil)
        print("GPS location executed")
        print()
    }
    
    @IBAction func answerTriggerQuestion(_ sender: Any) {
        print("click answer btn")
        print(answerTxtLbl.text!)
        if quiz.verifyAnswer(ans: answerTxtLbl.text!){
            print("correct")
            dismiss(animated: true, completion: nil)
        }else{
            print("nom count: \(Const.nominees.count)")
            if Const.nominees.count != 0{
               
                tPresenter.executeSMSInUrgent(nominee: Const.nominees,currentAddress:addressLocation)
                
                let alert = UIAlertController(title: "We sent SMS to your nominee", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                
                self.present(alert, animated: true)
            }else{
                print("No nominee")
                let alert = UIAlertController(title: "You are not well, you might need to get assistance", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)}))
                
                self.present(alert, animated: true)
            }
        }
        Const.TIMER_IS_TRIGGERED = false
    }
}


