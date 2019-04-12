//
//  DatePickerCell.swift
//  Laundry
//
//  Created by chanakya hirpara on 2/23/19.
//  Copyright © 2019 chanakya hirpara. All rights reserved.
//

import UIKit

class DatePickerCell: UICollectionViewCell {

    @IBOutlet weak var dayLbl: UILabel!
    
    var date : Date = Date() {
        didSet {
            dayLbl.text = date.getDayNumber()
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.contentView.backgroundColor = UIColor.red
                self.dayLbl.textColor = .black
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                self.dayLbl.textColor = UIColor(hexString: "#DDDDDD")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
