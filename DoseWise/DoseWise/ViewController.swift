//
//  ViewController.swift
//  DoseWise
//
//  Created by Hasini Vasudevan on 24/8/18.
//  Copyright © 2018 Monash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let smstrig = SmsTrigger()
        smstrig.SendSms(To:"+61481080828",Body:"Hi there! Your friend isn't responding quite well. Could you please check if everything is good?")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

