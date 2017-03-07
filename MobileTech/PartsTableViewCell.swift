//
//  PartsTableViewCell.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit

class PartsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.partTextField.delegate = self
    }

}

extension PartsTableViewCell : UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
       let viewContoller = UIApplication.shared.windows[0].rootViewController!.childViewControllers.first as! FloatersViewController
        viewContoller.parts[textField.tag] = textField.text!
        print(viewContoller.parts)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let viewContoller = UIApplication.shared.windows[0].rootViewController!.childViewControllers.first as! FloatersViewController
        viewContoller.parts[textField.tag] = textField.text!
        print(viewContoller.parts)
        
        return true
    }
    
}
