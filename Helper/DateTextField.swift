//
//  DateTextField.swift
//  TrueBlue
//
//  Created by Diksha Rattan on 29/11/21.
//

import Foundation
import UIKit
//protocol DateTextFieldDelegate: AnyObject {
//    func dateDidChange(dateTextField: DateTextField)
//}

public class DateTextField: NSObject {

    public enum Format: String {
        case monthYear = "MM'$'yy"
        case dayMonthYear = "dd'*'MM'$'yyyy"
        case monthDayYear = "MM'$'dd'*'yyyy"
        case yearMonthDay = "yyyy'&'MM'$'dd"
        
        func format(separator: String) -> String {
            return self.rawValue
                .replacingOccurrences(of: "$", with: separator)
                .replacingOccurrences(of: "*", with: separator)
                .replacingOccurrences(of: "&", with: separator)
        }
    }
    var textField = UITextField()
    // MARK: - Properties
    private let dateFormatter = DateFormatter()
    private let alwaysVisiblePlaceHolder = UILabel()

    /// The order for which the date segments appear. e.g. "day/month/year", "month/day/year", "month/year"
    /// **Default:** `Format.dayMonthYear`
    public var dateFormat = Format.dayMonthYear

    /// The symbol you wish to use to separate each date segment. e.g. "01 - 01 - 2012", "01 / 03 / 2019"
    /// **Default:** `" / "`
    public var separator: String = " / "
    //weak var customDelegate: DateTextFieldDelegate?

    /// Parses the `text` property into a `Date` and returns that date if successful.
    /// If unsuccessful, the value will be nil and you'll need to show this in your UI.
    public var date: Date? {
        get {
            dateFormatter.dateFormat = dateFormat.format(separator: separator)
            return dateFormatter.date(from: textField.text ?? "")
        }
        set {
            if newValue != nil {
                dateFormatter.dateFormat = dateFormat.format(separator: separator)
                textField.text = dateFormatter.string(from: newValue!)
            } else {
                textField.text = nil
            }
        }
    }

//    // MARK: - Lifecycle
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        super.delegate = self
//        keyboardType = .numberPad
//        autocorrectionType = .no
//
//        insertSubview(alwaysVisiblePlaceHolder, at: 0)
//        alwaysVisiblePlaceHolder.backgroundColor = backgroundColor
//        backgroundColor = .clear
//    }

    func numberOnlyString(with string: String) -> String? {
        let expression = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: string.count)
        let digitOnlyRegex = try? NSRegularExpression(pattern: "[^0-9]+",
                                                          options: NSRegularExpression.Options(rawValue: 0))
        return digitOnlyRegex?.stringByReplacingMatches(in: string, options: expression, range: range, withTemplate: "")
    }
    
    func dateTxtFld(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
//            customDelegate?.dateDidChange(dateTextField: self)
            return true
        }

        guard let swiftRange = textField.text?.getRange(from: range) else {
            return false
        }
        guard let replacedString = textField.text?.replacingCharacters(in: swiftRange, with: string) else {
            return false
        }

        // Because you never know what people will paste in here, and some emoji have numbers present.
        let emojiFreeString = replacedString.stringByRemovingEmoji()
        guard let numbersOnly = numberOnlyString(with: emojiFreeString) else {
            return false
        }

        switch dateFormat {
        case .monthYear:
            guard numbersOnly.count <= 4 else { return false }
            let splitString = split(string: numbersOnly, format: [2, 2])
            let month = splitString.count > 0 ? splitString[0] : ""
            let year = splitString.count > 1 ? splitString[1] : ""
            validteDateCopy(day: "", month: month, year: year)
            //validteDate(day: "", month: month, year: year)
//            textField.text = final(day: "", month: month, year: year)
        case .dayMonthYear:
            guard numbersOnly.count <= 8 else { return false }
            let splitString = split(string: numbersOnly, format: [2, 2, 4])
            let day = splitString.count > 0 ? splitString[0] : ""
            let month = splitString.count > 1 ? splitString[1] : ""
            let year = splitString.count > 2 ? splitString[2] : ""
            print(day)
            print(month)
            print(year)
            validteDate(day: day, month: month, year: year)
            //textField.text = final(day: day, month: month, year: year)
        case .monthDayYear:
            guard numbersOnly.count <= 8 else { return false }
            let splitString = split(string: numbersOnly, format: [2, 2, 4])
            let day = splitString.count > 1 ? splitString[1] : ""
            let month = splitString.count > 0 ? splitString[0] : ""
            let year = splitString.count > 2 ? splitString[2] : ""
            textField.text = final(day: day, month: month, year: year)
        case .yearMonthDay:
            guard numbersOnly.count <= 8 else { return false }
            let splitString = split(string: numbersOnly, format: [4, 2, 2])
            let year = splitString.count > 0 ? splitString[0] : ""
            let month = splitString.count > 1 ? splitString[1] : ""
            let day = splitString.count > 2 ? splitString[2] : ""
            textField.text = final(day: day, month: month, year: year)
        }
       // customDelegate?.dateDidChange(dateTextField: self)
        return false
    }
    
    func timeTxtFld(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
//            customDelegate?.dateDidChange(dateTextField: self)
            return true
        }

        guard let swiftRange = textField.text?.getRange(from: range) else {
            return false
        }
        guard let replacedString = textField.text?.replacingCharacters(in: swiftRange, with: string) else {
            return false
        }

        // Because you never know what people will paste in here, and some emoji have numbers present.
        let emojiFreeString = replacedString.stringByRemovingEmoji()
        guard let numbersOnly = numberOnlyString(with: emojiFreeString) else {
            return false
        }
        guard numbersOnly.count <= 8 else { return false }
        let splitString = split(string: numbersOnly, format: [2, 2])
        let hour = splitString.count > 0 ? splitString[0] : ""
        let minutes = splitString.count > 1 ? splitString[1] : ""
        validateTime(hour: hour, minutes: minutes)
        return false
    }
    
//    func checkIfDayExists(year:Int,month:Int,day:Int) -> Bool {
//
//       let dateComponents = DateComponents(year: year, month: month)
//       let calendar = Calendar.current
//       let date = calendar.date(from: dateComponents)!
//
//       let numberOfDays = calendar.range(of: .day, in: .month, for: date)!
//       return numberOfDays.count >= day
//    }
//    func checkIfMonthExists(year:Int,month:Int,day:Int) -> Bool {
//
//       let dateComponents = DateComponents(year: year, month: month)
//       let calendar = Calendar.current
//       let date = calendar.date(from: dateComponents)!
//
//       let numberOfDays = calendar.range(of: .day, in: .month, for: date)!
//       return numberOfDays.count >= day
//    }
    
//    func isValid(date: String) {
//        let dateFormatter = DateFormatter()
//        switch dateFormat {
//        case .monthYear:
//            dateFormatter.dateFormat = "MM-yyyy"
//        case .dayMonthYear:
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//        case .monthDayYear:
//            dateFormatter.dateFormat = "MM-dd-yyyy"
//        case .yearMonthDay:
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//        }
//        //dateFormatter.dateFormat = "dd-MM-yyyy"
//
//        if let date = dateFormatter.date(from: date) {
//            print(date) // if this prints date is valid
//        }
//        else {
//            print("Date is Invalid") // if this prints date is invalid
//        }
//    }
    
    func validateTime(hour: String,minutes: String) {
        let hourInt = Int(hour) ?? 0
        let minutesInt = Int(minutes) ?? 0
        var validHour = hour
        var validMinutes = minutes
        if hour.count == 2 {
            if hourInt > 23 || hourInt == 0 {
                validHour = "23"
            }
        }
//        else if hour.count == 1 {
//            if hourInt > 2 {
//                validHour = "02"
//            }
//        }
        
        if minutes.count == 2 {
            if minutesInt > 59 {
                validMinutes = "00"
            }
        } else if minutes.count == 1 {
            if minutesInt > 5 {
                validMinutes = "0\(minutes)"
            }
        }
        textField.text = final(hour: validHour, minutes: validMinutes)
    }
    
    func validteDate(day: String,month: String,year: String) {
        let dayInt = Int(day) ?? 0
        let monthInt = Int(month) ?? 0
        let yearInt = Int(year) ?? 0
        let month31 = [1,3,5,7,8,10,12]
        let month30 = [4,6,9,11]
        var validDay = day
        var validMonth = month
        let validYear = year
        if day.count == 2 {
            if month.isEmpty {
                //Day should not be greater than 31
                if dayInt > 31 {
                    validDay = "31"
                }
            } else {
                if month30.contains(monthInt) {
                    if dayInt > 30 {
                        validDay = "30"
                    }
                } else if month31.contains(monthInt) {
                    if dayInt > 31 {
                        validDay = "31"
                    }
                } else if monthInt == 2  {//User can also type zero
                    //Feb
                    if year.count == 4 {
                        if isLeapYear(year: yearInt) {
                            if dayInt > 29 {
                                validDay = "29"
                            }
                        } else {
                            if dayInt > 28 {
                                validDay = "28"
                            }
                        }
                    } else {
                        if dayInt > 29 {
                            validDay = "29"
                        }
                    }
                }
            }
        } else if day.count == 1 {
            if dayInt > 3 {
                validDay = "0\(day)"
            }
        }
        
        if month.count == 2 {
            if monthInt > 12 {
                validMonth = "12"
            }
        } else if month.count == 1 {
            if monthInt > 1 {
                validMonth = "0\(month)"
            }
        }
        textField.text = final(day: validDay, month: validMonth, year: validYear)
    }
    
    func validteDateCopy(day: String,month: String,year: String) {
        let dayInt = Int(day) ?? 0
        let monthInt = Int(month) ?? 0
        let yearInt = Int(year) ?? 0
        let month31 = [1,3,5,7,8,10,12]
        let month30 = [4,6,9,11]
        var validDay = day
        var validMonth = month
        let validYear = year
        if day.count == 2 {
            if month.isEmpty {
                //Day should not be greater than 31
                if dayInt > 31 {
                    validDay = "31"
                }
            } else {
                if month30.contains(monthInt) {
                    if dayInt > 30 {
                        validDay = "30"
                    }
                } else if month31.contains(monthInt) {
                    if dayInt > 31 {
                        validDay = "31"
                    }
                } else if monthInt == 2  {//User can also type zero
                    //Feb
                    if year.count == 4 {
                        if isLeapYear(year: yearInt) {
                            if dayInt > 29 {
                                validDay = "29"
                            }
                        } else {
                            if dayInt > 28 {
                                validDay = "28"
                            }
                        }
                    } else {
                        if dayInt > 29 {
                            validDay = "29"
                        }
                    }
                }
            }
        } else if day.count == 1 {
            if dayInt > 3 {
                validDay = "0\(day)"
            }
        }
        
        if month.count == 2 {
            if monthInt > 12 {
                validMonth = "12"
            }
        } else if month.count == 1 {
            if monthInt > 1 {
                validMonth = "0\(month)"
            }
        }
        textField.text = finalCopy(day: validDay, month: validMonth, year: validYear)
    }
    
    func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else {
            return (year % 4 == 0)
        }
    }
    
    func split(string: String, format: [Int]) -> [String] {

        var mutableString = string
        var splitString = [String]()

        for item in format {
            if mutableString.count == 0 {
                break
            }
            if mutableString.count >= item {
                let index = string.index(mutableString.startIndex, offsetBy: item)
                splitString.append(String(mutableString[..<index]))
                mutableString.removeSubrange(Range(uncheckedBounds: (mutableString.startIndex, index)))
            } else {
                splitString.append(mutableString)
                mutableString.removeSubrange(Range(uncheckedBounds: (mutableString.startIndex, mutableString.endIndex)))
            }
        }

        return splitString
    }

    func final(day: String, month: String, year: String) -> String {

        var dateString = dateFormat.rawValue
        dateString = dateString.replacingOccurrences(of: "dd", with: day)
        dateString = dateString.replacingOccurrences(of: "MM", with: month)
        dateString = dateString.replacingOccurrences(of: "yyyy", with: year)

        if day.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "*", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "*", with: "")
        }
        if month.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "$", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "$", with: "")
        }
        if year.count >= 4 {
            dateString = dateString.replacingOccurrences(of: "&", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "&", with: "")
        }

        return dateString.replacingOccurrences(of: "'", with: "")
    }
    
    func finalCopy(day: String, month: String, year: String) -> String {

        var dateString = dateFormat.rawValue
        dateString = dateString.replacingOccurrences(of: "dd", with: day)
        dateString = dateString.replacingOccurrences(of: "MM", with: month)
        dateString = dateString.replacingOccurrences(of: "yy", with: year)

        if day.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "*", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "*", with: "")
        }
        if month.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "$", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "$", with: "")
        }
        if year.count >= 4 {
            dateString = dateString.replacingOccurrences(of: "&", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "&", with: "")
        }

        return dateString.replacingOccurrences(of: "'", with: "")
    }
    
    
    func final(hour: String, minutes: String) -> String {

        var dateString = "hh'$'mm"
        dateString = dateString.replacingOccurrences(of: "hh", with: hour)
        dateString = dateString.replacingOccurrences(of: "mm", with: minutes)

        if hour.count >= 2 {
            dateString = dateString.replacingOccurrences(of: "$", with: separator)
        } else {
            dateString = dateString.replacingOccurrences(of: "$", with: "")
        }
        return dateString.replacingOccurrences(of: "'", with: "")
    }

}

//// MARK: - UITextFieldDelegate
//extension DateTextField: UITextFieldDelegate {
//
//    public func textField(
//        _ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if string.count == 0 {
//          //  customDelegate?.dateDidChange(dateTextField: self)
//            return true
//        }
//
//        guard let swiftRange = textField.text?.getRange(from: range) else {
//            return false
//        }
//        guard let replacedString = textField.text?.replacingCharacters(in: swiftRange, with: string) else {
//            return false
//        }
//
//        // Because you never know what people will paste in here, and some emoji have numbers present.
//        let emojiFreeString = replacedString.stringByRemovingEmoji()
//        guard let numbersOnly = numberOnlyString(with: emojiFreeString) else {
//            return false
//        }
//
//        switch dateFormat {
//        case .monthYear:
//            guard numbersOnly.count <= 6 else { return false }
//            let splitString = split(string: numbersOnly, format: [2, 4])
//            let month = splitString.count > 0 ? splitString[0] : ""
//            let year = splitString.count > 1 ? splitString[1] : ""
//            textField.text = final(day: "", month: month, year: year)
//        case .dayMonthYear:
//            guard numbersOnly.count <= 8 else { return false }
//            let splitString = split(string: numbersOnly, format: [2, 2, 4])
//            let day = splitString.count > 0 ? splitString[0] : ""
//            let month = splitString.count > 1 ? splitString[1] : ""
//            let year = splitString.count > 2 ? splitString[2] : ""
//            textField.text = final(day: day, month: month, year: year)
//        case .monthDayYear:
//            guard numbersOnly.count <= 8 else { return false }
//            let splitString = split(string: numbersOnly, format: [2, 2, 4])
//            let day = splitString.count > 1 ? splitString[1] : ""
//            let month = splitString.count > 0 ? splitString[0] : ""
//            let year = splitString.count > 2 ? splitString[2] : ""
//            textField.text = final(day: day, month: month, year: year)
//        case .yearMonthDay:
//            guard numbersOnly.count <= 8 else { return false }
//            let splitString = split(string: numbersOnly, format: [4, 2, 2])
//            let year = splitString.count > 0 ? splitString[0] : ""
//            let month = splitString.count > 1 ? splitString[1] : ""
//            let day = splitString.count > 2 ? splitString[2] : ""
//            textField.text = final(day: day, month: month, year: year)
//        }
//      //  customDelegate?.dateDidChange(dateTextField: self)
//        return false
//    }

//    func split(string: String, format: [Int]) -> [String] {
//
//        var mutableString = string
//        var splitString = [String]()
//
//        for item in format {
//            if mutableString.count == 0 {
//                break
//            }
//            if mutableString.count >= item {
//                let index = string.index(mutableString.startIndex, offsetBy: item)
//                splitString.append(String(mutableString[..<index]))
//                mutableString.removeSubrange(Range(uncheckedBounds: (mutableString.startIndex, index)))
//            } else {
//                splitString.append(mutableString)
//                mutableString.removeSubrange(Range(uncheckedBounds: (mutableString.startIndex, mutableString.endIndex)))
//            }
//        }
//
//        return splitString
//    }
//
//    func final(day: String, month: String, year: String) -> String {
//
//        var dateString = dateFormat.rawValue
//        dateString = dateString.replacingOccurrences(of: "dd", with: day)
//        dateString = dateString.replacingOccurrences(of: "MM", with: month)
//        dateString = dateString.replacingOccurrences(of: "yyyy", with: year)
//
//        if day.count >= 2 {
//            dateString = dateString.replacingOccurrences(of: "*", with: separator)
//        } else {
//            dateString = dateString.replacingOccurrences(of: "*", with: "")
//        }
//        if month.count >= 2 {
//            dateString = dateString.replacingOccurrences(of: "$", with: separator)
//        } else {
//            dateString = dateString.replacingOccurrences(of: "$", with: "")
//        }
//        if year.count >= 4 {
//            dateString = dateString.replacingOccurrences(of: "&", with: separator)
//        } else {
//            dateString = dateString.replacingOccurrences(of: "&", with: "")
//        }
//
//        return dateString.replacingOccurrences(of: "'", with: "")
//    }

//}

// MARK: - String Extension
extension String {

    fileprivate func getRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex,
                                     offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex,
                                   offsetBy: nsRange.location + nsRange.length,
                                   limitedBy: utf16.endIndex),
            let start = from16.samePosition(in: self),
            let end = to16.samePosition(in: self)
            else { return nil }
        return start ..< end
    }

    fileprivate func stringByRemovingEmoji() -> String {
        return String(self.filter { !$0.isEmoji() })
    }

}

// MARK: - Character Extension
extension Character {
    fileprivate func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Date() // Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func year(using calendar: Calendar = .current) -> Int {
        calendar.component(.year, from: self)
    }
    func month(using calendar: Calendar = .current) -> Int {
        calendar.component(.month, from: self)
    }
    
    func getMonthDates() -> [Date] {
//        let now = Date()
        let year = self.year()
        let month = self.month()
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        
        let components = range.map { day -> DateComponents in
            let date = DateComponents(calendar: .current, year: year, month: month, day: day).date!
            return Calendar.current.dateComponents([.weekday, .day, .month, .year], from: date)
        }
        
        return components.map{ Calendar.current.date(from: $0)! }
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
//        if years(from: date)   > 0 { return "\(years(from: date)) Years"   }
//        if months(from: date)  > 0 { return "\(months(from: date)) Months" }
//        if weeks(from: date)   > 0 { return "\(weeks(from: date)) Weeks"   }
        if days(from: date)    > 0 { return "\(days(from: date)) Days"     }
//        if hours(from: date)   > 0 { return "\(hours(from: date)) Hours"   }
        
//        let dayHourMinuteSecond: Set<Calendar.Component> = [.day]
//        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
//        
//        let days = "\(difference.day ?? 0)d"
//        print(days)
//        if let day = difference.day, day          > 0 { return days }
        return ""
    }
}
