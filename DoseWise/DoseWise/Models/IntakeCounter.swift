//
//  intakeTracker.swift
//  composingFunc
//
//  Created by 郭成俊 on 8/9/18.
//  Copyright © 2018 Monash. All rights reserved.
//

import Foundation

//this class

class intakeCounter{
    let defaults = UserDefaults.standard
    var curDate = "01.01.1970"
    
    
    //dateType is the format of the date, dateType2 will only be used for presenting current date to user
    let dateType1="dd.MM.yyyy"
    let dateType2="E, MMM d, yyyy"
    
    func getNoOfPillsPerDay()->Int{
        var listOfSchedule=CRUDDrugSchedule().getDrugSchdules()
        var firstSchedule:DrugSchedule
        firstSchedule = listOfSchedule[0]
        var noOfIntake = firstSchedule.no_of_times_per_day
        return noOfIntake!
    }
    
    //add current counting
    func increaseCounting(){
        let theRegister = defaults.array(forKey: "register")
        let max:Int = (theRegister?.count)!-1
        var currentCounting = defaults.integer(forKey: "counting")
        if currentCounting < max {
            currentCounting += 1
            defaults.set(currentCounting, forKey: "counting")
            print("func_increaseCounting currentCounting = "+String(currentCounting))
            
        } else {
            print("func_increaseCounting exceed max")
            print("max = "+String(max))
            print("func_increaseCounting currentCounting = "+String(currentCounting))
            refresh()
        }
    }
    
    //reset counting value in NSUserDefault
    func resetCounting(){
        defaults.set(0, forKey: "counting")
    }
    
    func getCounting()->Int{
        let currentCounting = defaults.integer(forKey: "counting")
        return currentCounting
    }
    
    //change the coorespondent value in register, indicate that have user took their drug for the time or not
    func confirming(isTaken:Bool){
        increaseCounting()
        let currentCounting = defaults.integer(forKey: "counting")
        var theRegister = defaults.array(forKey: "register")
        print("func_yesIHave currentCounting = "+String(currentCounting))
        
        if isTaken {
            theRegister![currentCounting]=1
        } else {
            theRegister![currentCounting]=0
        }
        
        defaults.set(theRegister, forKey: "register")
        let theRegister2 = defaults.array(forKey: "register")
        
        print(theRegister2)
        
        //        will not check for the 1st time
        //        if last index cooresponding val is 0
        //        invoke logAquiz()
        
        if currentCounting != 0 {
            var lastIntakeIdex=currentCounting-1
            let lastIntakeRegoVal:Int=theRegister2![lastIntakeIdex] as! Int
            if  lastIntakeRegoVal == 0 {
                logAQuiz()
            }
            
        }
        
    }
    
    //this is where to log a quiz
    func logAQuiz(){
        //call quiz notification here, such as set a quiz 30 min later
        print("user missed last intake, logging a quiz for 5 mins later")
    }
    
    
    //    1, get @curDate from USUserDefault
    //    2, get todays date
    //    3, compare them, if not equal, reset @curDate and intakeRegister
    func refreshByDate(){
        let storedDate = defaults.string(forKey: "curDate")
        
        let todaysDate = getCurrentDateStr(dateType: dateType1)
        let isEqual = (storedDate == todaysDate)
        
        if !isEqual{
            print("func_refresh called")
            refresh()
        }
        print("func_refresh: storedDate = "+storedDate!)
        //        print("func_refresh: storedDate = "+storedDate)
        print("func_refresh: todaysDate = "+todaysDate)
    }
    
    //reset date/register/counting in NSUserDefaults
    func refresh(){
        
        storeDate()
        resetRegister(noOfIntake: getNoOfPillsPerDay())
        resetCounting()
    }
    
    //take number of intake per day in schedule, and create a register
    //a register is a list of number that indicate whether user took their drug or not
    //e.g. [1,1,0,1] this means user missed his 3rd intake for the day
    //in here it only create a list full of 0s
    func resetRegister(noOfIntake:Int){
        print("func_resetRegister called")
        var intakeRegister:Array<Int> = []
        for i in 0..<noOfIntake{
            intakeRegister.append(0)
        }
        defaults.set(intakeRegister, forKey: "register")
    }
    
    //store the current to NSUserDefault
    func storeDate(){
        
        let strDate = getCurrentDateStr(dateType: dateType1)
        defaults.set(strDate, forKey: "curDate")
    }
    
    //get the String of current date in designated format
    
    func getCurrentDateStr(dateType:String)->String{
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat=dateType
        let currentDateStr=formatter.string(from: date)
        return currentDateStr
    }
    
}
