//
//  SlidingDatePicker.swift
//  Laundry
//
//  Created by chanakya hirpara on 2/23/19.
//  Copyright © 2019 chanakya hirpara. All rights reserved.
//

import UIKit


private class PickerPreferences {
    var font : UIFont = UIFont.systemFont(ofSize: 14)
}

struct DateInfo {
    var DayString   : String
    var MonthString : String
    var YearString  : String
    
    var DayNumber : String
}

class SlidingDatePicker: UIView {
    
    fileprivate var preferences : PickerPreferences = PickerPreferences()
    
    fileprivate var focusedIndexPath : IndexPath? = nil
    fileprivate var dateList:[Date] = []
    fileprivate var isScrolling:Bool = false

    var nextArrowImage : UIImage!
    var prevArrowImage : UIImage!
    
    typealias dateSelectionClosure = (Date, DateInfo) -> Void
    var dateSelectionAction:dateSelectionClosure? = nil {
        didSet {
            if oldValue == nil {
                let selectedIndexPath = IndexPath(row: 1, section: 0)
                if collectionView.validate(indexPath: selectedIndexPath) {
                    selectCellAt(indexPath: selectedIndexPath)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func initWith(previousNumberofDays:Int = 1, maximum:Int = 2, component: Calendar.Component = .day) {
        
        guard let todayDate = Calendar.current.date(byAdding: component, value: -(previousNumberofDays+1), to: Date()) else {
            return
        }

        if let lastSupportedDate = Calendar.current.date(byAdding: component, value: maximum, to: todayDate) {
            dateList = CalendarHelper.datesBetween(todayDate, lastSupportedDate)
        }
        
        collectionView.reloadData()
        
        let selectedIndexPath = IndexPath(row: 1, section: 0)
        if collectionView.validate(indexPath: selectedIndexPath) {
            selectCellAt(indexPath: selectedIndexPath)
        }
    }
    
    fileprivate func font() -> UIFont {
        return UIFont(name: "EurostileRegular", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    
    lazy var monthLabel : UILabel = {
        let label = UILabel()
        label.font = font()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dayLabel : UILabel = {
        let label = UILabel()
        label.font = font()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setImage(nextArrowImage, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onNext), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func onNext() {
        if let visiblePath = collectionView.indexPathsForSelectedItems?.sorted().first {
            let nextIndexPath = visiblePath.next()
            if collectionView.validate(indexPath: nextIndexPath) {
                selectCellAt(indexPath: nextIndexPath)
            }
        }
    }
    
    @objc func onPrev() {
        if let visiblePath = collectionView.indexPathsForSelectedItems?.sorted().first {
            let prevIndexPath = visiblePath.prev()
            if collectionView.validate(indexPath: prevIndexPath) {
                selectCellAt(indexPath: prevIndexPath)
            }
        }
    }
    
    lazy var prevButton : UIButton = {
        let button = UIButton()
        button.setImage(prevArrowImage, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onPrev), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width / 3, height: frame.width)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        let cellNib = UINib(nibName: "DatePickerCell", bundle: Bundle(for: DatePickerCell.self))
        collectionView.register(cellNib, forCellWithReuseIdentifier: "DatePickerCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    func setupUI() {
        
        let bundle = Bundle(for: SlidingDatePicker.self)
        
        nextArrowImage = UIImage(named: "next_dark_arrow@2x.png", in: bundle, compatibleWith: nil)!
        prevArrowImage = UIImage(named: "prev_dark_arrow@2x.png", in: bundle, compatibleWith: nil)!

        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([.top, .bottom, .right, .left].map {
            NSLayoutConstraint(item: collectionView as Any, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
        })

        addSubview(monthLabel)
        addSubview(dayLabel)
        
        dayLabel.text = "SUNDAY"
        monthLabel.text = "FEBRUARY"
        
        let monthLabelHeight = monthLabel.getTextHeight() + 15
        
        self.addConstraint(NSLayoutConstraint(item: monthLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 1.0))
        monthLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -monthLabelHeight).isActive = true
        
        let dayLabelHeight = dayLabel.getTextHeight() + 15
        
        dayLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: 1.0).isActive = true
        dayLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: dayLabelHeight).isActive = true
        
        addSubview(nextButton)
        addSubview(prevButton)
        
        nextButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.12).isActive = true
        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: collectionView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: collectionView.frame.width / 6 ))
        self.addConstraint(NSLayoutConstraint(item: nextButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nextButton, attribute: NSLayoutConstraint.Attribute.width
            , multiplier: ( 60.0/35.0 ), constant: 1 ))
        
        prevButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        prevButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor, multiplier: 1.0).isActive = true
        prevButton.heightAnchor.constraint(equalTo: nextButton.heightAnchor, multiplier: 1.0).isActive = true
        self.addConstraint(NSLayoutConstraint(item: prevButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: collectionView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: -(collectionView.frame.width / 6)))
        
    }

}

extension SlidingDatePicker : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
        dateCell.date = dateList[indexPath.row]
        
        return dateCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    
    func stoppedScrolling() {
        let visiblePaths = collectionView.indexPathsForVisibleItems
        print(visiblePaths.map({ $0.row }))
        focusedIndexPath = visiblePaths.sorted().middle
        if let focused = focusedIndexPath {
            selectCellAt(indexPath: focused)
        }
    }
    
    func selectCellAt(indexPath:IndexPath) {
        if indexPath.row < dateList.count - 1 && indexPath.row > 0 {
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.27) { [weak self] in
                if let collect = self?.collectionView {
                    collect.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
                }
            }
            
            let dateFetched = self.dateList[indexPath.row]
            
            let dayNumber = dateFetched.getDayNumber()
            let dayString = dateFetched.getDayName()
            let monthString = dateFetched.getMonthName()
            let yearString      = dateFetched.getYearNumber()
            
            dateSelectionAction?(self.dateList[indexPath.row], DateInfo(DayString: dayString, MonthString: monthString, YearString: yearString, DayNumber: dayNumber))
            
            changeLabel(label: self.dayLabel, text: dayString)
            changeLabel(label: self.monthLabel, text: monthString)
            
        }
    }
    
    func changeLabel(label:UILabel, text:String) {
        UIView.transition(with: label, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            label.text = text
        }, completion: { (finished: Bool) -> () in
            label.text = text
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return (indexPath.row < dateList.count - 1 && indexPath.row > 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAt(indexPath: indexPath)
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return focusedIndexPath
    }
}

extension UICollectionView {
    func validate(indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections {
            return false
        }
        if indexPath.row >= numberOfItems(inSection: indexPath.section) {
            return false
        }
        return true
    }
}

extension IndexPath {
    func next() -> IndexPath {
        return IndexPath(row: row + 1, section: section)
    }
    
    func prev() -> IndexPath {
        return IndexPath(row: row - 1, section: section)
    }
}

extension UILabel {
    func getTextHeight() -> CGFloat {
        let textString = self.text! as NSString
        let textAttributes = [NSAttributedString.Key.font: self.font]
        let textRect = textString.boundingRect(with: CGSize(width: self.frame.width, height: 2000), options: .usesLineFragmentOrigin, attributes: textAttributes as [NSAttributedString.Key : Any], context: nil)
        return textRect.height
    }
}

extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}

extension Date {
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func getDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).uppercased()
    }
    
    func getYearNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}

extension UIColor {
    func colorWithRGB(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat=1) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

