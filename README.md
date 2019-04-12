# SlidingDatePicker
Awesome Horizontal Sliding Date Picker Written in Swift!

Below is the code about how to use this SlidingDatePicker :

@IBOutlet weak var datePicker: SlidingDatePicker! // This is the outlet of datePicker
@IBOutlet weak var dateLbl: UILabel! // This is the label printing currently selected Date
    
var currentSelectedDate : Date? = nil // This variable stores selected date
    
override func viewDidLoad() {
  super.viewDidLoad()
  // Do any additional setup after loading the view, typically from a nib.

  /* previousNumberofDaysMonthOrYear is the day/month/year supported for start of date,
   *   maximum is the day/month/year supported for last date,
   *   component can be month, year, day depends on your start or end date
   */
  datePicker.initWith(previousNumberofDaysMonthOrYear: 1, maximum: 1, component: Calendar.Component.month) 
  
  /* dateSelectionAction is called whenever datepicker is slided
   * it returns Date, 
     DateInfo (DateInfo is custom struct that contain DayNumber(eg. 1-30), DayString(eg. MONDAY-SUNDAY),                            MonthString(eg. JANUARY-DECEMBER), YearString(eg. 2019,2020,.... ))
   */
  
  datePicker.dateSelectionAction = { (date, dateInfo) in
    self.currentSelectedDate = date
    self.dateLbl.text = "\(dateInfo.DayNumber)(\(dateInfo.DayString))-\(dateInfo.MonthString)-\(dateInfo.YearString)"
  }
}
