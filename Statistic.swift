//
//  Statistic.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 22/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit

class Statistic:NSObject{
    
    func getTotal(listData:NSArray) -> NSNumber{
        var total:NSNumber = 0
        var i:Int
        for(i = 0; i < listData.count; i++){
            var tableRow:Stanza = listData[i] as Stanza
            total = NSNumber (integer: (total.integerValue)+(tableRow.letturaAttuale.integerValue))
        }
        return total
    }
    
    func getTotal (listData:NSArray, withMonth num:Int) -> NSNumber{
        var total:NSNumber = 0
        var i:Int
        for(i = 0; i < listData.count; i++){
            var tableRow:Stanza = listData[i] as Stanza
            total = NSNumber(integer: (total.integerValue)+(tableRow.arrayLetture[num].integerValue))
        }
        return total
    }
    
}




