//
//  CALayer+BorderColor.swift
//  Gank
//
//  Created by AHuaner on 2017/2/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

extension CALayer {
    var XibBorderColor: UIColor? {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        set(boderColor) {
            self.borderColor = boderColor?.cgColor
        }
    }
}
