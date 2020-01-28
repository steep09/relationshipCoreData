//
//  FoodCell.swift
//  coreDataRelationship
//
//  Created by Stephenson Ang on 1/28/20.
//  Copyright © 2020 Stephenson Ang. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    func configureCell(food: Foods) {
        self.nameLbl.text = food.name
    }

}
