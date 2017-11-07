//
//  DesignableView.swift
//  vodic kulturnih dogadanja
//
//  Created by Faculty of Organisation and Informatics on 04/11/2017.
//  Copyright © 2017 foi. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }

    }

}
