//
//  IncomeList.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 08/05/23.
//

import Foundation
import CloudKit

struct Income{
    var recordId: CKRecord.ID?

    let idUser: String
    let month:Int
    let year:Int
    let method:String
    let value:Decimal
    
    init(recordId: CKRecord.ID? = nil,  idUser: String, month: Int, year: Int, value: Decimal, method:String) {
        self.recordId = recordId

        self.idUser = idUser
        self.month = month
        self.year = year
        self.value = value
        self.method = method
    }
    func toDictionary()->[String:Any]{
        return ["idUser":idUser,"month":month,"year":year,"value":value,"method":method]
    }
    static func fromRecord(_ record:CKRecord)->Income?{
        guard  let idUser = record.value(forKey:"idUser") as? String, let month = record.value(forKey:"month") as? Int,
              let year = record.value(forKey:"year") as? Int,let value = record.value(forKey:"value") as? Double, let method = record.value(forKey: "method") as? String
        else {
            return nil
        }
        return Income(recordId: record.recordID, idUser: idUser, month: month, year: year, value: Decimal(value), method: method)
    }
}
struct IncomeModel{
    let income:Income
    
    var recordId: CKRecord.ID?{
        income.recordId
    }
    var idUser: String{
        income.idUser
    }
    var month:Int{
        income.month
    }
    var year:Int{
        income.year
    }
    var value:Decimal{
        income.value
    }
    var method:String{
        income.method
    }
}
