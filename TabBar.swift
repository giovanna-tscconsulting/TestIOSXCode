//
//  TabBar.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 19/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBarController {//, UITabBarControllerDelegate {
    
    var resultAppartamento:String!
    var resultPalazzo:String!
    var actualMonth:NSNumber!
    var inquiliniList:NSArray!
    var inquiliniPianoList:NSArray!
    var usernameGestore:String!
    var usernameAdmin:String!
    var arrayPercRispPalazzo:NSMutableArray!
    var edificiList:NSArray!
    var adminsList:NSArray!
    var listAcs:NSArray!
    var listData:NSArray!
    var potTermicaPalazzo:NSNumber!
    var totaleConsumiPalazzo:NSNumber!
    var totaleConsumiAbitazione:NSNumber!
    var urlPalazzo:String!
    var urlAbitazione:String!
    var inquilinoUsername:String!
    
    
    @IBOutlet var window:UIWindow!
    //@IBOutlet var tabBarController:UITabBarController!
    
    
     override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //tabBarController = UITabBarController()
       
        
        let storyboard = UIStoryboard(name: "UserListVC", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("UserListVC") as UserListViewController
        vc.listData = self.listData
        vc.urlPalazzo = urlPalazzo
        vc.urlAbitazione = urlAbitazione
        vc.totaleConsumiPalazzo = self.totaleConsumiPalazzo
        vc.jsonPalazzo = self.resultPalazzo
        vc.jsonAppartamento = self.resultAppartamento
        vc.usernameAdmin = self.usernameAdmin
        vc.inquiliniList = self.inquiliniList
        vc.inquiliniPianoList = self.inquiliniPianoList
        vc.arrayPercRispPalazzo = self.arrayPercRispPalazzo
        vc.edificiList = self.edificiList
        vc.adminsList = self.adminsList
        vc.listAcs = self.listAcs
        vc.potTermicaPalazzo = self.potTermicaPalazzo
        vc.usernameGestore = self.usernameGestore
        vc.inquilinoUsername = self.inquilinoUsername
        vc.monthInitializer = NSNumber (int: 0)
        
        let storyboard2 = UIStoryboard(name: "PieChartViewC", bundle: nil)
        let vc2 = storyboard2.instantiateViewControllerWithIdentifier("PieChartVC") as PieChartViewController
        vc2.listData = self.listData
        vc2.urlPalazzo = urlPalazzo
        vc2.urlAbitazione = urlAbitazione
        println(urlAbitazione)
        vc2.totalePalazzo = self.totaleConsumiPalazzo
        vc2.totaleAbitazione = self.totaleConsumiAbitazione
        vc2.jsonPalazzo = self.resultPalazzo
        vc2.jsonAppartamento = self.resultAppartamento
        vc2.usernameAdmin = self.usernameAdmin
        vc2.listInquilini = self.inquiliniList
        vc2.inquiliniPianoList = self.inquiliniPianoList
        vc2.arrayPercRispPalazzo = self.arrayPercRispPalazzo
        vc2.edificiList = self.edificiList
        vc2.listAdmins = self.adminsList
        vc2.listAcs = self.listAcs
        vc2.potTermicaPalazzo = self.potTermicaPalazzo
        vc2.usernameGestore = self.usernameGestore
        vc2.inquilinoUsername = self.inquilinoUsername
        vc2.monthInitializer = NSNumber (int: 0)

        
        let storyboard3 = UIStoryboard(name: "InfoVC", bundle: nil)
        let vc3 = storyboard3.instantiateViewControllerWithIdentifier("InfoVC") as InfoViewController
       
        if(usernameGestore != nil){
        vc3.usernameGestore = self.usernameGestore
        }else if(usernameAdmin != nil){
            vc3.usernameAdmin = usernameAdmin
        }else{
            vc3.inquilinoUsername = inquilinoUsername
        }
        
        
        var controllers:NSArray = NSArray (objects: vc, vc2, vc3)
        self.viewControllers = controllers
        
        var tabs:NSArray = controllers
        var tab1:UIViewController = tabs[0] as UIViewController
        tab1.tabBarItem.image = UIImage (named: "icona_lista.png")
        tab1.tabBarItem.title = "Lista"
        
        var tab2:UIViewController = tabs[1] as UIViewController
        tab2.tabBarItem.image = UIImage (named: "icona_torta.png")
        tab2.tabBarItem.title = "Grafico"
        
        var tab3:UIViewController = tabs[2] as UIViewController
        tab3.tabBarItem.image = UIImage(named: "icona_info.png")
        tab3.tabBarItem.title = "Info"
        
      //  view.addSubview(tabBarController?.view)!

    }
    
    
    func hideTabBar(tabbarcontroller:UITabBarController){
        tabbarcontroller.tabBar.hidden = true
    }

    
      
   
    }


