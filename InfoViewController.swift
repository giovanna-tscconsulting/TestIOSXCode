//
//  InfoViewController.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 09/01/15.
//  Copyright (c) 2015 com.tsc. All rights reserved.
//

import Foundation
import UIKit


class InfoViewController : UIViewController{
    
    var usernameGestore:String!
    var usernameAdmin:String!
    var inquilinoUsername:String!
    @IBOutlet var userLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(usernameGestore != nil){
        userLabel.text = capitalizeFirstCharacter (usernameGestore)
        }else if(usernameAdmin != nil){
            userLabel.text = capitalizeFirstCharacter(usernameAdmin)
        }else{
            userLabel.text = capitalizeFirstCharacter(inquilinoUsername)
        }
    }
    
    
    
    func capitalizeFirstCharacter (toCapitalize:String) -> String{
        toCapitalize.lowercaseString
        var flcString:String = toCapitalize.capitalizedString
        return flcString
    }
    
    @IBAction func openClimagestSite (){
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.climagest.it")!)
    }
    
    @IBAction func openTscSite(){
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.tsc-consulting.com")!)
    }
    
    @IBAction func openAtaglanceSite(){
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.ataglance.it")!)
    }
    
    @IBAction func logout(){
        var pieVC:ViewController = ViewController()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as NSString
        var path = documentsDirectory.stringByAppendingPathComponent("MyFile9.plist")
        var fileManager = NSFileManager.defaultManager()
        fileManager.removeItemAtPath(path, error: nil)
        self.presentViewController(pieVC, animated: true, completion: nil)
    }
    
}
