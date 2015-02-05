//
//  Checkbox.swift
//  ProvaJoule2
//
//  Created by TSC Consulting on 05/02/15.
//  Copyright (c) 2015 com.tsc. All rights reserved.
//

import Foundation
import UIKit

class Checkbox : UIButton {
    //var mDelegate: CheckboxDelegate?;
    // #1
    required init(coder: NSCoder) {
        super.init();
    }
    
    // #2
    init(frame: CGRect, title: String, selected: Bool) {
        super.init(frame: frame);
        self.adjustEdgeInsets();
        self.applyStyle();
        self.setTitle(title, forState: UIControlState.Normal);
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func adjustEdgeInsets() {
        let lLeftInset: CGFloat = 8.0;
        // #3
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        // #4
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, lLeftInset, 0.0 as CGFloat, 0.0 as CGFloat);
        // #5
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, (lLeftInset * 2), 0.0 as CGFloat, 0.0 as CGFloat);
    }
    
    // #6
    func applyStyle() {
        self.setImage(UIImage(named: "checked_checkbox.png"), forState: UIControlState.Selected);
        self.setImage(UIImage(named: "unchecked_checkbox.png"), forState: UIControlState.Normal);
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
    }
    
    func onTouchUpInside(sender: UIButton) {
        // #7
        self.selected = !self.selected;
        // #8
       // mDelegate?.didSelectCheckbox(self.selected, identifier: self.tag, title: self.titleLabel.text);
    }
}