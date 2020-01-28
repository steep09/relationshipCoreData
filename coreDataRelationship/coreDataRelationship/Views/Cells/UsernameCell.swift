//
//  UsernameCell.swift
//  coreDataRelationship
//
//  Created by Stephenson Ang on 1/28/20.
//  Copyright © 2020 Stephenson Ang. All rights reserved.
//

import UIKit

class UsernameCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    
    func configureCell(username: UserName) {
        self.nameLbl.text = username.name
        self.ageLbl.text = "\(username.age)"
    }

}
