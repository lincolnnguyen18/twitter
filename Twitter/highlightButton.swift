//
//  highlightButton.swift
//  Twitter
//
//  Created by Lincoln Nguyen on 2/13/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class highlightButton: UIButton {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var isHighlighted: Bool {
        didSet {
            
            if (isHighlighted) {
                // self.backgroundColor = #colorLiteral(red: 0.1066790186, green: 0.6003596351, blue: 0.903967756, alpha: 1)
                self.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.568627451, blue: 0.8549019608, alpha: 1)
            }
            else {
                self.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
            }
            
        }
    }

}
