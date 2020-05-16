//
//  TableViewCell.swift
//  EnternProject
//
//  Created by Мухтарпаша on 16.05.2020.
//  Copyright © 2020 Magomed Inc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var customImageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customImageCell.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
