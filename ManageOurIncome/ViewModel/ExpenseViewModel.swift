//
//  ExpenseViewModel.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 12/05/23.
//

import Foundation
import SwiftUI
import CloudKit
class ExpenseViewModel:ObservableObject{
    private var database:CKDatabase
    private var container:CKContainer
    @Published var items:[ExpenseModel]=[]
    @Published var loading:Bool=false
    @Published var errorMessage:String=""
    @Published var error:Bool=false
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    
    func deleteItem(_ recordId: CKRecord.ID,idIncome:CKRecord.ID){
        
        database.delete(withRecordID: recordId){
            deleteRecordId, error in
            if let error = error{
                print(error)
            }
            self.populateItem(idIncome: idIncome)
        }
    }
  
    func saveItem(idIncome: CKRecord.ID,type:Int,value:Decimal,description:String){
        let record = CKRecord(recordType: RecordType.expense.rawValue)
        let reference = CKRecord.Reference(recordID:idIncome, action: .deleteSelf)
        record["idIncome"] = reference as CKRecordValue
        record["type"] = type as CKRecordValue
        record["value"] = value as CKRecordValue
        record["description"] = description as CKRecordValue
//        guard let idIncome = record["idIncome"]?.description as? String else{return}
//        print("idincome:",idIncome)
//        let expenseListing = Expense(idIncome:idIncome, description: description, type: type, value: value)
//        record.setValuesForKeys(
//
//        )
        
        self.database.save(record){
            newRecord, error in
            if let error = error{
               

                print("error",error.localizedDescription)
            }
            else{
                
                if let newRecord = newRecord{
                    if let expense = Expense.fromRecord(newRecord){
                        DispatchQueue.main.async {
                            self.items.append(ExpenseModel(expense: expense))
                            print("Saved")
                           
                        }
                    }
                }
                
            }
        }
        
    }
    func populateItem(idIncome:CKRecord.ID){
        var items : [Expense] = []
        let reference = CKRecord.Reference(recordID: idIncome, action: .deleteSelf)
        let query = CKQuery(recordType:RecordType.expense.rawValue, predicate: NSPredicate(format: "idIncome == %@", reference))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.loading=true
        database.fetch(withQuery:query){
            result in
            switch result{
            case .success(let result):
                result.matchResults.compactMap{ $0.1 }
                    .forEach{
                        switch $0{
                        case .success(let record):
                           
                            if let expense = Expense.fromRecord(record){
                                items.append(expense)
                                
                            }

                        case .failure(let error):
                            print(error)
                                            }
                    }
                DispatchQueue.main.async {
                    self.items = items.map(ExpenseModel.init)
                    self.loading=false
                }
                
            case .failure(let error):
                self.error=true
                self.errorMessage="Failed Get Data"
                print(error)
            }
        }
    }
    
    
}
