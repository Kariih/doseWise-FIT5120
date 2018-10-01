//
//  TermViewController.swift
//  DoseWise
//
//  Created by 郭成俊 on 25/9/18.
//  Copyright © 2018 Monash. All rights reserved.
//

import Foundation
import UIKit

//this class is for disclaimer, 28/09
class TermViewController: UIViewController {
    let defaults = UserDefaults.standard
    let inputVali = inputValidator()
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPhoneNo: UITextField!
    @IBOutlet weak var nameValidationMessage: UILabel!
    @IBOutlet weak var phoneNoValidationMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameValidationMessage.isHidden=true
        phoneNoValidationMessage.isHidden=true
        
        // Adding webView content
        do {
            guard let filePath = Bundle.main.path(forResource: "Copyofterms_conditions_v2", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
        
        //keyboard call listening
        NotificationCenter.default.addObserver(self, selector: #selector(TermViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TermViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //push or pull the view when keyboard is called
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //by clicking agree, userInput will be validated and saved
    @IBAction func agreeTheTermAndCondition(_ sender: Any) {
        nameValidationMessage.isHidden=true
        phoneNoValidationMessage.isHidden=true
        
        guard let aUserName = userName.text, userName.text?.characters.count != 0 else {
            nameValidationMessage.isHidden=false
            nameValidationMessage.text="Please enter your full name"
            return
        }
        
        if inputVali.validateName(name: userName.text!) == false{
            nameValidationMessage.isHidden=false
            nameValidationMessage.text="Please enter a valid name"
        }else{
            storeUserName(name: userName.text!)
        }
        
        guard let aUserPhone = userPhoneNo.text, userPhoneNo.text?.characters.count != 0 else {
            phoneNoValidationMessage.isHidden=false
            phoneNoValidationMessage.text="Please enter your phone number"
            return
        }
        
        if inputVali.validatePhoneNo(phoneNo: userPhoneNo.text!) == false{
            phoneNoValidationMessage.isHidden=false
            phoneNoValidationMessage.text="Please enter a valid phone number"
        }else{
            storeUserPhoneNo(phoneNo: userPhoneNo.text!)
        }
        
    }
    
    //store userName to NSUserDefaults
    func storeUserName(name:String){
        let aName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        defaults.set(aName, forKey: "userName")
    }
    
    //store userPhoneNo to NSUserDefaults
    func storeUserPhoneNo(phoneNo:String){
        let aPhone = phoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        defaults.set(aPhone, forKey: "userPhoneNo")
    }
    
}
