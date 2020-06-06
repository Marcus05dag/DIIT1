//
//  TableSecondCell.swift
//  EnternProject
//
//  Created by Мухтарпаша on 05.06.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit

class TableSecondCell: UITableViewCell {

    @IBOutlet weak var tableCustomCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableCustomCell.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
