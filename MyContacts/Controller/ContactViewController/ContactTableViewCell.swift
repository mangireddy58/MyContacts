//
//  ContactTableViewCell.swift
//  MyContacts
//
//  Created by Mangi on 8/15/19.
//  Copyright © 2019 BajajAllianz. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var contactLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
