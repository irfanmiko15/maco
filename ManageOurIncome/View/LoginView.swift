//
//  LoginView.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 08/05/23.
//

import SwiftUI
import AuthenticationServices
import CloudKit
struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("Email") var email:String=""
    @AppStorage("firstName") var firstName:String=""
    @AppStorage("lastName") var lastName:String=""
    @AppStorage("userId") var userId:String=""
    @AppStorage("token") var token:String=""
    let container = CKContainer(identifier: "iCloud.com.irfan.ManageOurIncome")
    private var isSignedIn:Bool{
        !token.isEmpty
    }
    var body: some View {
       
            if(!isSignedIn){
                NavigationStack{
                    ZStack{
                        VStack{
                            
                        }.frame(maxWidth: .infinity).frame(maxHeight: .infinity).background(Color.greenColor).opacity(0.9)
                        Circle().fill(
                            Color(.white)
                        ).offset(x:100).offset(y:-300).opacity(0.2).frame(height:200)
                        Circle().fill(
                            Color(.white)
                        ).offset(x:100).offset(y:-300).opacity(0.19).frame(height:300)
                        
                        Circle().fill(
                            Color(.white)
                        ).offset(x:100).offset(y:-300).opacity(0.18).frame(height:500)
                        
                        
                        VStack(alignment: .leading){
                            Text("Sign In").font(.system(size: 40).bold()).padding(.leading).foregroundColor(.white)
                            Spacer()
                            HStack{
                                Spacer()
                                Image("wallet").resizable().scaledToFit().frame(height: 250)
                                Spacer()
                            }
                            Spacer()
                           
                            Text("Manage Your Monthly Income Wisely").font(.system(size: 35).bold()).padding(.leading).foregroundColor(.white)
                            Text("A New Way That Makes It Easier For You to Allocate Monthly Income").foregroundColor(.white).font(.system(size:20)).padding(.horizontal).padding(.top)
                            SignInWithAppleButton(.continue){request in
                                request.requestedScopes = [.email, .fullName]
                            } onCompletion: { result in
                                switch result {
                                case .success(let auth):
                                    switch auth.credential{
                                    case let credential as ASAuthorizationAppleIDCredential:
                                        let email = credential.email
                                        let firstName = credential.fullName?.givenName
                                        let lastName = credential.fullName?.familyName
                                        let userId = credential.user
                                        
                                        if (email != nil){
                                            self.token="token"
                                            self.email = email ?? ""
                                            self.firstName = firstName ?? ""
                                            self.lastName = lastName ?? ""
                                            self.userId = userId
                                        }
                                        else{
                                            self.token="token"
                                        }
                                        
                                     
                                        
                                    default:
                                        break;
                                    }
                                case.failure(let error):
                                    print(error)
                                }
                            } .signInWithAppleButtonStyle(.white )
                                .frame(height: 50).cornerRadius(5).padding()
                            
                        }.frame(maxHeight: .infinity).padding()
                    }.frame(maxWidth: .infinity).frame(maxHeight: .infinity)
                        
                }
            }
        else{
            HomeView(vm: IncomeViewModel(container: container))
            }

        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
