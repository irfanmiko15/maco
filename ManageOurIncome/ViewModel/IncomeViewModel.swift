//
//  IncomeViewModel.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 08/05/23.
//

import Foundation
import CloudKit
import SwiftUI
enum RecordType:String{
    case income = "Income"
    case expense = "Expense"
}
class IncomeViewModel:ObservableObject{
    private var database:CKDatabase
    private var container:CKContainer
    @Published var items:[IncomeModel]=[]
    @Published var loading:Bool=false
    @Published var errorMessage:String=""
    @Published var error:Bool=false
    @AppStorage("userId") var userId:String=""
    
    init(container: CKContainer) {
      
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    func deleteItem(_ recordId: CKRecord.ID){
        database.delete(withRecordID: recordId){
            deleteRecordId, error in
            if let error = error{
                print(error)
            }
            self.populateItem()
        }
    }
  
    func saveItem(idUser: String,month:Int,year:Int,value:Decimal,method:String){
        let record = CKRecord(recordType: RecordType.income.rawValue)
        let incomeListing = Income(idUser: idUser, month: month, year: year, value: value,method:method)
        record.setValuesForKeys(incomeListing.toDictionary())
        
        self.database.save(record){
            newRecord, error in
            if let error = error{
                print(error)
            }
            else{
                
                if let newRecord = newRecord{
                    if let income = Income.fromRecord(newRecord){
                       
                        DispatchQueue.main.async {
                            
                            self.items.append(IncomeModel(income: income))
                            
                            print("Saved")
                           
                        }
                        
                    }
                }
                
            }
        }
        
    }
    func populateItem(){
        var items : [Income] = []
        let query = CKQuery(recordType:RecordType.income.rawValue, predicate: NSPredicate(format: "idUser == %@", userId))
        query.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false),NSSortDescriptor(key: "month", ascending: false)]
        self.loading=true
        database.fetch(withQuery:query){
            result in
            switch result{
            case .success(let result):
                result.matchResults.compactMap{ $0.1 }
                    .forEach{
                        switch $0{
                        case .success(let record):
                            
                            if let income = Income.fromRecord(record){
                                items.append(income)
                            }
                        case .failure(let error):
                            print(error)
                                            }
                    }
                DispatchQueue.main.async {
                    self.items = items.map(IncomeModel.init)
                    self.loading=false
                }
                
            case .failure(let error):
                self.loading=false
                self.error=true
                self.errorMessage="Failed Get Data"
                print(error)
            }
        }
    }
    
    
}





