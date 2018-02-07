//
//  AddKnobSettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/3/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class AddKnobSettingCell: UITableViewCell {

  @IBOutlet weak var addKnobSettingButton: UIButton!
  
  let height: CGFloat = 150
  var isCellExpanded = false
  var heightExpansion: CGFloat {
    if isCellExpanded { return -height }
    else { return height }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func addKnobSetting(_ sender: Any) {
    UIView.animate(withDuration: 0.5) {
      self.addKnobSettingButton.frame.size.height += self.heightExpansion
    }
    isCellExpanded = !isCellExpanded
    print("Add Knob Setting")
  }
  
  @IBAction func collapseKnobView(_ sender: Any) {
    print("Cell is expanded : \(isCellExpanded)")
    if isCellExpanded {
      UIView.animate(withDuration: 0.5) {
        self.addKnobSettingButton.frame.size.height -= self.height
      }
    }
  }
 
}
