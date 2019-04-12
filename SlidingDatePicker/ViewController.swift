//
//  ViewController.swift
//  SlidingDatePicker
//
//  Created by chanakya hirpara on 4/10/19.
//  Copyright © 2019 Anam Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: SlidingDatePicker!
    @IBOutlet weak var dateLbl: UILabel!
    var currentSelectedDate : Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        datePicker.initWith(previousNumberofDays: 1, maximum: 1, component: Calendar.Component.month)
        datePicker.dateSelectionAction = { (date, dateInfo) in
            self.currentSelectedDate = date
            self.dateLbl.text = "\(dateInfo.DayNumber)(\(dateInfo.DayString))-\(dateInfo.MonthString)-\(dateInfo.YearString)"
        }
        
    }


}

