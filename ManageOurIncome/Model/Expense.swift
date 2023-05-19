//
//  Expense.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 12/05/23.
//

import Foundation
import CloudKit
struct Expense{
    var recordId: CKRecord.ID?
    let idIncome:CKRecord.ID
    let description: String
    let type:Int
    let value:Decimal
    let date:Date?
    
    init(recordId: CKRecord.ID? = nil, idIncome: CKRecord.ID, description: String, type: Int, value: Decimal,date:Date?) {
        self.recordId = recordId
        self.idIncome = idIncome
        self.description = description
        self.type = type
        self.value = value
        self.date = date
    }
    
    static func fromRecord(_ record:CKRecord)->Expense?{
        guard  let idIncome = record.value(forKey:"idIncome") as? CKRecord.Reference, let description = record.value(forKey:"description") as? String,
               let type = record.value(forKey:"type") as? Int,let value = record.value(forKey:"value") as? Double,let date = record.value(forKey: "creationDate")as? Date
                
        else {
            return nil
        }
        
        return Expense(recordId: record.recordID, idIncome: idIncome.recordID, description: description, type: type, value: Decimal(value),date: date)
    }
    
}
struct ExpenseModel{
    let expense:Expense
    
    var recordId: CKRecord.ID?{
        expense.recordId
    }
    var idIncome: CKRecord.ID?{
        expense.idIncome
    }
    var type:Int{
        expense.type
    }
    
    var value:Decimal{
        expense.value
    }
    var description:String{
        expense.description
    }
    var date:Date?{
        expense.date
    }
}
