//
//  DetailIncomeView.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 11/05/23.
//

import SwiftUI
import CloudKit
import Combine
struct DetailIncomeView: View {
    @Binding var income:IncomeModel
    @StateObject private var vm: ExpenseViewModel
    init(vm:ExpenseViewModel,income:Binding<IncomeModel>){
        _vm = StateObject(wrappedValue: vm)
        self._income = income
    }
    @State private var showSuccess=false
    @State private var showLoading=false
    @State private var showingConfirmation=false
    @State private var recordId:CKRecord.ID?
    let container = CKContainer(identifier: "iCloud.com.irfan.ManageOurIncome")
    
    @State private var showingAddSheet = false
    func calculatePresentase(presntase:Decimal)->Decimal{
        var result1=Decimal(0)
        result1 = income.value*presntase
        return  result1
    }
    func getSisa()->Decimal{
        var result=income.value
        
        
        
            for it in vm.items{
                result = result-it.value
            }
            return result
    }
    
    var body: some View {
        LoadingView( isSuccess: $showSuccess, isShowing: $showLoading) {
            NavigationStack{
                ScrollView{
                    VStack{
                        ZStack{
                            Circle().fill(
                                Color(.white)
                            ).offset(x:-110).offset(y:-110).opacity(0.2).frame(height:50)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:-110).offset(y:-110).opacity(0.19).frame(height:100)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:-110).offset(y:-110).opacity(0.18).frame(height:180)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:110).offset(y:110).opacity(0.2).frame(height:50)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:110).offset(y:110).opacity(0.19).frame(height:100)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:110).offset(y:110).opacity(0.18).frame(height:180)
                            VStack(alignment: .leading){
                                HStack{
                                    
                                    Text("\(convertMonth(value:String(income.month))) \(String(income.year))").foregroundColor(.white).font(.system(size: 20))
                                    Spacer()
                                    
                                }.padding(.horizontal).padding(.top)
                                HStack{
                                    Text("\(convertToIDR(value:income.value))").foregroundColor(.white).font(.system(size: 22).bold()).foregroundColor(.black).padding(.horizontal).padding(.bottom)

                                    Spacer()
                                }
                                
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("Expenses Budget").font(.system(size: 15)).foregroundColor(.white)
                                        Text(convertToIDR(value:getSisa())).font(.system(size: 15).bold()).foregroundColor(.white)
                                    }
                                    Spacer()
                                    VStack(alignment: .leading){
                                        Text("Method").font(.system(size: 15)).foregroundColor(.white)
                                        Text(convertMethod(value:income.method)).font(.system(size: 15).bold()).foregroundColor(.white)
                                    }
                                }.padding(.horizontal)
                                
                                
                                
                                
                            }.padding(.bottom).frame(maxWidth: .infinity).frame(height: 180)
                        }.frame(height: 150).background(Color.greenColor).cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 0)
                            ).shadow(radius: 1).padding(.bottom,5).padding(.horizontal)
                       
                        calculateAllocation()
                    }
                    HStack{
                        Text("Your Expense").font(.system(size:20).bold())
                        Spacer()
                        Button(action: {
                            showingAddSheet=true
                        }){
                            Text("add").foregroundColor(Color.greenColor)
                        }
                        
                    }.padding(.horizontal).padding(.top,5)
                    
                    if(vm.loading){
                        HStack{
                            Spacer()
                            VStack{
                                
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle()).padding()
                                Spacer()
                            }
                            Spacer()
                        }.frame(height: 200)
                    }
                    else if(vm.error){
                        Text(vm.errorMessage)
                    }
                    else{
                        if(vm.items.count==0){
                            HStack{
                                Spacer()
                                
                                VStack{
                                    Spacer()
                                    Text("add your expense")
                                    Spacer()
                                }
                                Spacer()
                            }.frame(height: 150)
                            
                        }
                        else{
                            ForEach(vm.items.indices, id:\.self){
                                item in
                                HStack{
                                    
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text(vm.items[item].description).font(.system(size:17).bold())
                                            Text(vm.items[item].date!, style: .date).font(.system(size:15).bold())
                                        }
                                        
                                        Text(convertType(value:String(vm.items[item].type))).font(.system(size:13).bold())
                                            .foregroundColor(.gray)
                                            .padding(.bottom,0.1)
                                        Text("\(convertToIDR(value:vm.items[item].value))").font(.system(size:16).bold()).foregroundColor(Color.greenColor)
                                    }
                                    Spacer()
                                    Button(action: {
                                        self.showingConfirmation=true
                                        recordId=vm.items[item].recordId
                                        
                                    }){
                                        Image(systemName: "trash").font(.system(size:20)).foregroundColor(Color.greenColor).padding(.horizontal,10)
                                    }.confirmationDialog("You cannot undo this action?", isPresented: $showingConfirmation) {
                                        Button("Cancel", role: .cancel) { }
                                        Button("Delete This Data",role: .destructive) {
                                            self.showLoading=true
                                            print(recordId)
                                            if let recordIdd=recordId{
                                                vm.deleteItem(recordIdd, idIncome: income.recordId!)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                self.showSuccess=true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                                self.showLoading=false
                                                self.showSuccess=false
                                                
                                                
                                            }
                                        }
                                        
                                        
                                    } message: {
                                        Text("Are you sure delete this data?")
                                    }
                                    
                                }.padding(.horizontal).padding(.vertical,5)
                                    .background(Color.white).cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 0)
                                    ).shadow(radius: 1).padding(.bottom,5).padding(.horizontal)
                            }
                        }
                    }
                    
                    
                    
                }
                
                .sheet(isPresented: $showingAddSheet) {
                    
                    ExpenseSheetView(
                        
                        showLoading: $showLoading, showSuccess: $showSuccess,income:$income,vm:vm).environment(\.colorScheme, .light)
                }.onAppear{
                    if let recordName = income.recordId?.recordName{
                        vm.populateItem(idIncome: income.recordId!)
                    }
                    
                }
                .navigationTitle("Detail Income")
                
            }.refreshable{
                do{
                if let recordName = income.recordId?.recordName{
                    vm.populateItem(idIncome: income.recordId!)
                }
            }
                catch{
                    print("error")
                }
            }
            
            .accentColor(Color.greenColor)
        }
    }
    
    func getData(method:String,type:String)->Decimal{
        var result=Decimal(0)
        var result2=""
        switch method{
        case "1":
            switch type{
            case "1":
                let tempArr = vm.items.filter{$0.type == 1}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            case "2":
                let tempArr = vm.items.filter{$0.type == 2}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            case "3":
                let tempArr = vm.items.filter{$0.type == 3}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            default:
                break
            }
        case "2":
            switch type{
            case "1":
                let tempArr = vm.items.filter{$0.type == 1}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            case "2":
                let tempArr = vm.items.filter{$0.type == 2}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            case "3":
                let tempArr = vm.items.filter{$0.type == 3}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            case "4":
                let tempArr = vm.items.filter{$0.type == 4}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            default:
                break
            }
        case "3":
            switch type{
            case "1":
                let tempArr = vm.items.filter{$0.type == 1}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
                
            case "3":
                let tempArr = vm.items.filter{$0.type == 3}
                
                if(tempArr.count != 0){
                    for it in tempArr{
                        result = result+it.value
                    }
                    return result
                }
            default:
                break
            }
            
            
        default:
            break
        }
        return result
        
    }
    @ViewBuilder
    func calculateAllocation()->some View{
        switch income.method{
        case "1" :
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        
                        Text("My Allocation").font(.system(size: 15).bold())
                        Spacer()
                        
                    }.padding(.horizontal).padding(.top)
                    Divider()
                    HStack{
                        Image("grocery").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.greenColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5).padding(.top,5)
                        VStack(alignment: .leading){
                            
                            Text("Needs").font(.system(size: 15).bold()).padding(.bottom,3)
                            
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(1)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.50)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(1)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.50))),foregroundColor: Color.greenColor).frame(height: 5).padding(.trailing,5)
                            
                            
                        }
                    }
                    
                    HStack{
                        Image("want").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.blueColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5)
                        VStack(alignment: .leading){
                            
                            Text("Wants").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(2)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.30)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(2)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.30))),foregroundColor: Color.blueColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }
                    HStack{
                        Image("invest").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.orangeColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5)
                        VStack(alignment: .leading){
                            
                            Text("Saving / Investment").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(3)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.20)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(3)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.20))),foregroundColor: Color.orangeColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }.padding(.bottom)
                    
                    
                    
                }
                
                
            }
            .background(Color.white).cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 0)
            ).shadow(radius: 1).padding(.bottom,5).padding(.horizontal)
            
        case "2" :
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        
                        Text("My Allocation").font(.system(size: 15).bold())
                        Spacer()
                        
                    }.padding(.horizontal).padding(.top)
                    Divider()
                    HStack{
                        Image("grocery").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.greenColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5).padding(.top,5)
                        VStack(alignment: .leading){
                            
                            Text("Needs").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(1)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.40)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(1)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.40))),foregroundColor: Color.greenColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }
                    
                    HStack{
                        Image("want").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.blueColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5)
                        VStack(alignment: .leading){
                            
                            Text("Wants").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(2)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.30)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(2)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.30))),foregroundColor: Color.blueColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }
                    HStack{
                        Image("invest").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.orangeColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5)
                        VStack(alignment: .leading){
                            
                            Text("Saving / Investment").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(3)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.20)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(3)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.20))),foregroundColor: Color.orangeColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }
                    HStack{
                        Image("sedekah").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.pinkColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5)
                        VStack(alignment: .leading){
                            
                            Text("Sedekah / Zakat").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(4)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.10)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(4)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.10))),foregroundColor: Color.pinkColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }.padding(.bottom)
                    
                    
                }
                
                
            }
            .background(Color.white).cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 0)
            ).shadow(radius: 1).padding(.bottom,5).padding(.horizontal)
            
        case "3" :
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        
                        Text("My Allocation").font(.system(size: 15).bold())
                        Spacer()
                        
                    }.padding(.horizontal).padding(.top)
                    Divider()
                    HStack{
                        Image("grocery").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.greenColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5).padding(.top,5)
                        VStack(alignment: .leading){
                            
                            
                            Text("Needs").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(1)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.80)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(1)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.80))),foregroundColor: Color.greenColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }
                    
                    
                    HStack{
                        Image("invest").resizable().scaledToFit().frame(height: 35).padding(.horizontal,10).padding(.vertical,10).background(Color.orangeColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.horizontal,10).padding(.bottom,5)
                        VStack(alignment: .leading){
                            
                            Text("Saving / Needs").font(.system(size: 15).bold()).padding(.bottom,3)
                            Text("\(convertToIDR(value:getData(method:income.method,type: String(3)))) / \(convertToIDR(value: calculatePresentase(presntase: 0.20)))").font(.system(size: 15).bold())
                            ProgressBar(value:Double(NSDecimalNumber(decimal:getData(method:income.method,type: String(3)))),maxValue: Double(NSDecimalNumber(decimal:calculatePresentase(presntase: 0.20))),foregroundColor: Color.orangeColor).frame(height: 5).padding(.trailing,5)
                            
                        }
                    }.padding(.bottom)
                    
                    
                    
                }
                
                
            }
            .background(Color.white).cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 0)
            ).shadow(radius: 1).padding(.bottom,5).padding(.horizontal)
            
        default :
            Text("result")
        }
    }
}
struct ExpenseSheetView :View{
    @State var description: String = ""
    @State var value: String = ""
    @Binding var showLoading:Bool
    @Environment(\.dismiss) var dismiss
    @State private var selectedType=1
    @State private var showErrorAlert=false
    @Binding  var showSuccess:Bool
    @Binding var income:IncomeModel
    @ObservedObject var vm: ExpenseViewModel
    @State var type:[Int] = []
    func getSisa(val:Decimal)->Decimal{
        var result=income.value
        
        
        
            for it in vm.items{
                result = result-it.value
            }
            let a = result-val
            return a
    }
    func getType(){
        if(income.method=="1"){
            type.append(1)
            type.append(2)
            type.append(3)
        }
        else if(income.method=="2"){
            type.append(1)
            type.append(2)
            type.append(3)
            type.append(4)
        }
        else{
            type.append(1)
            type.append(3)
        }
    }
    
    var body: some View{
        LoadingView( isSuccess: $showSuccess, isShowing: $showLoading) {
            NavigationStack {
                VStack(alignment: .leading){
                    
                    
                    Form(content: {
                        // Text field
                        Section(header: Text("Expense form")) {
                            HStack(){
                                Text("Amount").padding(.trailing)
                                Spacer()
                                TextField("Insert your amount", text: $value).multilineTextAlignment(.trailing).keyboardType(.numberPad).onReceive(Just(value)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.value = filtered
                                    }
                                }
                            }
                            HStack(){
                                Text("Description").padding(.trailing)
                                Spacer()
                                TextField("Insert your description", text: $description).multilineTextAlignment(.trailing)
                                
                            }
                            
                            
                            
                            Picker("Type", selection:  $selectedType) {
                                ForEach(type, id: \.self) {
                                    Text(convertType(value: String($0)))
                                }
                            }
                            
                        }
                        Button(action: {
                            guard let amount = try?Decimal(value,format: .number) else { return}
                            print(getSisa(val:amount))
                            if(getSisa(val:amount)<0){
                                self.showErrorAlert=true
                            }
                            else{
                                showLoading=true
                                guard let amount = try?Decimal(value,format: .number) else { return}
                                
                                vm.saveItem(idIncome: income.recordId!, type: selectedType, value: amount, description: description)
                                
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    showSuccess=true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    showLoading=false
                                    showSuccess=false
                                    dismiss()
                                }
                            }
                            
                        }) {
                            HStack {
                                Spacer()
                                Text("Save").foregroundColor(Color.greenColor)
                                Spacer()
                            }
                        }.alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Failed"), message: Text("Overbudget"), dismissButton: .default(Text("OK")))
                        }
                        
                        
                    }).onAppear{
                        getType()
                        
                    }
                    
                }
                
                .navigationBarTitle( Text("Add Data"), displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                dismiss()
                            }){
                                Text("Cancel").foregroundColor(Color.greenColor)
                            }
                        }                }
                   
            }
        }
    }
}

struct DetailIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        DetailIncomeView(
            vm: ExpenseViewModel(container: CKContainer.default()),            income: .constant(IncomeModel(income: Income(idUser: "1", month: 1, year: 1, value: 2000000, method: "2"))))
    }
}
