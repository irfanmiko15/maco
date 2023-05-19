//
//  Utils.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 11/05/23.
//


import Foundation
import SwiftUI
import Combine
func convertToIDR(value:Decimal)->String{
    var result=""
    let formatter=NumberFormatter()
    formatter.locale=Locale(identifier: "id_ID")
    formatter.groupingSeparator="."
    formatter.numberStyle = .decimal
    if let formattedTipAmount = formatter.string(from: value as NSNumber) {
        result="Rp " + formattedTipAmount + ",00"
        
    }
    return result
}
func getFirstString(value:String)->String{
    var splitName=""
    let v = value[value.startIndex]
    splitName=String(v)
    return splitName
}
func convertMethod(value:String)->String{
    var result=""
    switch value{
    case "1" :
        result = "50/30/20"
    case "2" :
        result = "40/30/20/10"
    case "3" :
        result = "80/20"
    default :
        result=""
    }
    return result
}
func convertType(value:String)->String{
    var result=""
    switch value{
    case "1" :
        result = "Needs"
    case "2" :
        result = "Wants"
    case "3" :
        result = "Saving/Investment"
    case "4" :
        result = "Zakat/Sedekah"
    default :
        result=""
    }
    return result
}

func convertMonth(value:String)->String{
    var result=""
    switch value{
    case "1":
        result = "January"
    case "2":
        result = "February"
    case "3":
        result = "March"
    case "4":
        result = "April"
    case "5":
        result = "May"
    case "6":
        result = "June"
    case "7":
        result = "July"
    case "8":
        result = "August"
    case "9":
        result = "September"
    case "10":
        result = "October"
    case "11":
        result = "November"
    case "12":
        result = "Desember"
    default:
        result = ""
    }
    return result
}

func greetingLogic() -> String {
  let hour = Calendar.current.component(.hour, from: Date())
  
  let NEW_DAY = 0
  let NOON = 12
  let SUNSET = 18
  let MIDNIGHT = 24
  
  var greetingText = "Hello" // Default greeting text
  switch hour {
  case NEW_DAY..<NOON:
      greetingText = "Good Morning"
  case NOON..<SUNSET:
      greetingText = "Good Afternoon"
  case SUNSET..<MIDNIGHT:
      greetingText = "Good Evening"
  default:
      _ = "Hello"
  }
  
  return greetingText
}
class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
