//
//  HomeView.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 08/05/23.
//

import SwiftUI
import Combine
import CloudKit

struct HomeView: View {
    @StateObject private var vm: IncomeViewModel
    @State var color=[Color.greenColor,Color.orangeColor,Color.pinkColor]
    init(vm:IncomeViewModel){
        _vm = StateObject(wrappedValue: vm)
    }
    @AppStorage("Email") var email:String=""
    @AppStorage("firstName") var firstName:String="test"
    @AppStorage("lastName") var lastName:String=""
    @AppStorage("userId") var userId:String=""
    @State private var showSuccess=false
    @State private var showLoading=false
    @State private var showingConfirmation=false
    @State private var recordId:CKRecord.ID?
    let container = CKContainer(identifier: "iCloud.com.irfan.ManageOurIncome")
    
    @State private var showingProfileSheet = false
    @State private var showingIncomeSheet = false
    
    func calculateTotalIncome()->String{
        var result1=Decimal(0)
        for it in vm.items{
            result1 = result1+it.value
        }
        
        
        return (convertToIDR(value: result1))
    }
    
    
    
    
    
    var body: some View {
        LoadingView( isSuccess: $showSuccess, isShowing: $showLoading) {
            NavigationStack{
                ScrollView{
                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Text("Hello,\(firstName)" ).font(.system(size: 20))
                                Text(greetingLogic() ).font(.system(size: 15))
                            }
                            Spacer()
                            Text(getFirstString(value:firstName))
                                .padding()
                                .background(.gray)
                                .foregroundColor(.white)
                                .font(.system(size: 35).bold())
                                .clipShape(Circle()).onTapGesture {
                                    showingProfileSheet.toggle()
                                }
                        }
                        
                        
                        
                        ZStack{
                            Circle().fill(
                                Color(.white)
                            ).offset(x:100).offset(y:-100).opacity(0.2).frame(height:80)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:100).offset(y:-100).opacity(0.19).frame(height:150)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:100).offset(y:-100).opacity(0.18).frame(height:230)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:-100).offset(y:100).opacity(0.2).frame(height:80)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:-100).offset(y:100).opacity(0.19).frame(height:150)
                            Circle().fill(
                                Color(.white)
                            ).offset(x:-100).offset(y:100).opacity(0.18).frame(height:230)
                            VStack{
                                Text("Total Income").font(.system(size: 18).bold()).foregroundColor(.white)
                                Text("\(calculateTotalIncome())").font(.system(size: 25).bold()).foregroundColor(.white)
                                
                                
                                
                            }.frame(maxWidth: .infinity).frame(height: 180)
                        }.frame(height: 150).background( Color.greenColor ).cornerRadius(20)
                        
                        HStack{
                            Text("Your Income").font(.system(size:18).bold())
                            Spacer()
                            Button(action: {
                                showingIncomeSheet.toggle()
                            }){
                                Text("add").foregroundColor(Color.greenColor)
                            }
                            
                        }.padding(.vertical,5)
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
                            }.frame(height: 300)
                            
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
                                        Text("add your income")
                                        Spacer()
                                    }
                                    Spacer()
                                }.frame(height: 300)
                                
                            }
                            else{
                                ForEach(vm.items.indices, id: \.self){
                                    
                                    item in
                                    
                                    HStack{
                                        VStack(alignment: .leading){
                                            HStack{
                                                Image(systemName: "calendar").font(.system(size:18)).foregroundColor(Color.greenColor).padding(.vertical,10).padding(.horizontal,10).background(Color.greenColor.opacity(0.3)).cornerRadius(10).opacity(0.8).padding(.trailing,10)
                                                Text("\(convertMonth(value:String(vm.items[item].month)))").font(.system(size: 17).bold())
                                                Text(String((vm.items[item].year))).font(.system(size: 17).bold()).foregroundColor(.black)
                                                Spacer()
                                                Button(action: {
                                                    showingConfirmation=true
                                                    recordId=vm.items[item].recordId
                                                }){
                                                    
                                                    Image(systemName: "trash").font(.system(size:20)).foregroundColor(Color.greenColor).padding(.horizontal,5)
                                                }.confirmationDialog("You cannot undo this action?", isPresented: $showingConfirmation) {
                                                    Button("Cancel", role: .cancel) { }
                                                    Button("Delete This Data",role: .destructive) {
                                                        self.showLoading=true
                                                        
                                                        if let recordIdd=recordId{
                                                            vm.deleteItem(recordIdd)
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
                                                
                                                
                                                
                                                
                                            }.padding(.top,10).padding(.horizontal,10)
                                            HStack{
                                                VStack(alignment: .leading){
                                                    Text("Income").font(.system(size: 15)).padding(.horizontal,10)
                                                    Text(convertToIDR(value:vm.items[item].value)).font(.system(size: 15).bold()).foregroundColor(Color.greenColor).padding(.horizontal,10)
                                                }
                                                Spacer()
                                                VStack(alignment: .leading){
                                                    Text("Metode").font(.system(size: 15)).padding(.horizontal,10)
                                                    Text(convertMethod(value:vm.items[item].method)).font(.system(size: 15).bold()).foregroundColor(Color.greenColor).padding(.horizontal,10)
                                                }
                                            }
                                            
                                            Divider().padding(.horizontal,10)
                                            
                                            NavigationLink {
                                                DetailIncomeView(
                                                    
                                                    vm: ExpenseViewModel(container: container)                ,income: $vm.items[item])
                                            } label: {
                                                Text("Detail").padding().frame(maxWidth:.infinity).foregroundColor(.white).background(Color.greenColor).cornerRadius(10).padding(.horizontal,10).padding(.vertical,10)
                                                
                                                
                                                
                                            }
                                            
                                        }.frame(maxWidth: .infinity)
                                    }
                                    .background(Color.white).cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 0)
                                    ).shadow(radius: 2).padding(.horizontal,1).padding(.bottom,5)
                                    
                                    
                                }
                                
                            }
                        }
                        
                        
                    }
                    .sheet(isPresented: $showingIncomeSheet) {
                        
                        IncomeSheetView(showLoading: $showLoading, showSuccess: $showSuccess, isEdit: .constant(false), vm: vm).environment(\.colorScheme, .light)
                    }
                    
                    
                    .sheet(isPresented: $showingProfileSheet) {
                        
                        DetailProfile(showingSheet: $showingProfileSheet).environment(\.colorScheme, .light)
                    }
                    
                }.padding()
                    .onAppear{
                        vm.populateItem()
                    }
            }
            .refreshable{
                vm.populateItem()
            }
        }
    }
}
struct IncomeSheetView:View{
   
    @AppStorage("Email") var email:String=""
    @AppStorage("firstName") var firstName:String=""
    @AppStorage("lastName") var lastName:String=""
    @AppStorage("userId") var userId:String=""
    @State private var showingAlert = false
    @State private var isDuplicate=false
    @State private var isCalculate=false
    @Binding var showLoading:Bool
    @State private var showErrorAlert=false
    @Binding  var showSuccess:Bool
    //    @Binding var showingSheet:Bool
    @Binding var isEdit:Bool
    @State var name: String = ""
    @State var value: String = ""
    @ObservedObject var input = NumbersOnly()
    @FocusState private var amountIsFocused: Bool
    @Environment(\.dismiss) var dismiss
    @State private var selectedMonthValue=1
    @State private var defaultValueMonth="Choose Month"
    @State private var selectedYear = 2023
    @State private var selectedMethod = "1"
    @ObservedObject var vm: IncomeViewModel
    let monthValue=[1,2,3,4,5,6,7,8,9,10,11,12]
    let year = [2023, 2024, 2025,2026,2027,2028,2029,2030,2031,2032,2033,2034]
    let method = ["1","2","3"]
    func cekDuplicate(){
        
        for item in vm.items{
            if(item.month == selectedMonthValue && item.year == selectedYear){
                
                isDuplicate=true
            }
            
        }
    }
    
    func calculate()->String{
        var result1=Decimal(0)
        var result2=Decimal(0)
        var result3=Decimal(0)
        var result4=Decimal(0)
        var finalResult=""
        switch selectedMethod{
        case "1":
            let res1 = try?Decimal(value,format: .number)
            if let unwrap = res1 {
                let cal50 = unwrap * 50/100
                let cal30 = unwrap * 30/100
                let cal20 = unwrap * 20/100
                
                result1=cal50
                result2=cal30
                result3=cal20
                
            }
            
            finalResult="\n50%= \(convertToIDR(value: result1)) Untuk Kebutuhan \n\n30%= \(convertToIDR(value: result2)) Untuk Keinginan \n\n20%= \(convertToIDR(value: result3)) Untuk Investasi/Tabungan"
        case "2":
            let res1 = try?Decimal(value,format: .number)
            if let unwrap = res1 {
                let cal40 = unwrap * 40/100
                let cal30 = unwrap * 30/100
                let cal20 = unwrap * 20/100
                let cal10 = unwrap * 10/100
                
                result1=cal40
                result2=cal30
                result3=cal20
                result4=cal10
                
            }
            
            finalResult="\n40%= \(convertToIDR(value: result1)) Untuk Biaya Hidup \n\n30% = \(convertToIDR(value: result2)), \n\n20%= \(convertToIDR(value: result3)) Untuk Investasi/Tabungan \n\n10%= \(convertToIDR(value: result4)) Untuk Sedekah"
        case "3":
            let res1 = try?Decimal(value,format: .number)
            if let unwrap = res1 {
                let cal80 = unwrap * 80/100
                let cal20 = unwrap * 30/100
                
                
                result1=cal80
                result2=cal20
                
                
            }
            
            finalResult="\n80%= \(convertToIDR(value: result1)) Untuk Kebutuhan \n\n20%= \(convertToIDR(value: result2)) Untuk Tabungan/Investasi"
            
            
            
        default:
            result1=0
            result2=0
            result3=0
            result4=0
        }
        return finalResult
    }
    
    @ViewBuilder
    func calculateView()->some View{
        var result=convertMethod(value: selectedMethod)
        var finalResult=calculate()
        switch selectedMethod{
        case "1" :
            VStack(alignment: .leading){
                Text("Anda memilih \(result)")
                Text("Alokasikan gaji bulanan anda dengan rincian sebagai berikut")
                Text(finalResult)
            }.padding()
        case "2" :
            VStack(alignment: .leading){
                Text("Anda memilih \(result)")
                Text("Alokasikan gaji bulanan anda dengan rincian sebagai berikut")
                Text(finalResult)
            }.padding()
        case "3" :
            VStack(alignment: .leading){
                Text("Anda memilih \(result)")
                Text("Alokasikan gaji bulanan anda dengan rincian sebagai berikut")
                Text(finalResult)
            }.padding()
        default :
            Text(result)
        }
    }
    var body: some View{
        LoadingView( isSuccess: $showSuccess, isShowing: $showLoading) {
            NavigationStack {
                VStack(alignment: .leading){
                    
                    
                    Form(content: {
                        // Text field
                        Section(header: Text("Income form")) {
                            HStack(){
                                Text("Income").padding(.trailing)
                                Spacer()
                                TextField("Insert your income", text: $value).multilineTextAlignment(.trailing).keyboardType(.numberPad).onReceive(Just(value)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.value = filtered
                                    }
                                }.focused($amountIsFocused)
                            }
                            
                            
                            
                            Picker("Month", selection:  $selectedMonthValue) {
                                ForEach(monthValue, id: \.self) {
                                    Text(convertMonth(value: String($0)))
                                }
                            }
                            .pickerStyle(.navigationLink)
                            
                            
                            
                            
                            Picker("Year", selection: $selectedYear) {
                                ForEach(year, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(.navigationLink)
                            Picker("Method", selection: $selectedMethod) {
                                ForEach(method, id: \.self) {
                                    Text(convertMethod(value: $0))
                                }
                            }
                            Button(action: {
                                if(value != ""){
                                    isCalculate=true
                                    amountIsFocused=false
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Calculate").foregroundColor(Color.greenColor)
                                    Spacer()
                                }
                            }
                            
                            
                            
                        }
                        
                        
                        Button(action: {
                            showLoading=true
                            
                            cekDuplicate()
                            if(isDuplicate){
                                showLoading=false
                            }
                            else{
                                guard let amount = try?Decimal(value,format: .number) else { return}
                                vm.saveItem( idUser: userId, month: selectedMonthValue, year: selectedYear, value: amount,method: selectedMethod)
                                
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
                            Alert(title: Text("Error"), message: Text("Failed add data"), dismissButton: .default(Text("OK")))
                        }.alert(isPresented: $isDuplicate) {
                            Alert(title: Text("Error"), message: Text("Duplicate data, try again"), dismissButton: .default(Text("OK"),action: {
                                isDuplicate=false
                            }))
                        }
                        if(isCalculate && value != ""){
                            Section{
                                calculateView()
                            }
                        }
                        
                    }).onAppear{
                        vm.populateItem()
                    }
                    
                }.navigationBarTitle( Text("Add Data"), displayMode: .inline)
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

struct DetailProfile:View{
    @State private var showingAlert = false
    @AppStorage("Email") var email:String=""
    @AppStorage("firstName") var firstName:String=""
    @AppStorage("lastName") var lastName:String=""
    @AppStorage("userId") var userId:String=""
    @AppStorage("token") var token:String="token"
    @State private var sheetHeight: CGFloat = .zero
    @Binding var showingSheet:Bool
    @Environment(\.dismiss) var dismiss
    var body: some View{
        VStack(alignment: .center){
            Text(getFirstString(value:firstName))
                .padding(.vertical,20).padding(.horizontal,20)
                .background(.gray)
                .foregroundColor(.white)
                .font(.system(size: 50).bold())
                .clipShape(Circle())
            Text(email)
                .font(.system(size:25)).padding(.bottom,5)
            
            Text("\(firstName) \(lastName)").font(.system(size:25)).padding(.bottom)

            Button(action: {
                token=""
                dismiss()
            }){
                Text("Logout").font(.system(size:20).bold()).padding().frame(maxWidth:.infinity).foregroundColor(.white).background(Color.greenColor).cornerRadius(10).padding()
            }
        }.presentationDetents([.medium]).environment(\.colorScheme, .light)
        
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: IncomeViewModel(container: CKContainer.default()))
    }
}
