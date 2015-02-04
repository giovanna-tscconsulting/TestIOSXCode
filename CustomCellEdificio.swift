//
//  CustomCellEdificio.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 16/12/14.
//  Copyright (c) 2014 com.tsc. All rights reserved.
//

import Foundation
import UIKit

class CustomCellEdificio:UITableViewCell{
    
    @IBOutlet var nomeLbl: UILabel!
    @IBOutlet var percLbl: UILabel!
    @IBOutlet var arrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
