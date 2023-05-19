//
//  loadingIndicator.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 09/05/23.
//

import SwiftUI
struct LoadingView<Content>: View where Content: View {
    @Binding var isSuccess:Bool
    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    if(isSuccess){
                        VStack{
                            Text("Success").padding(.bottom,20)
                            Image(systemName: "checkmark").animation(Animation.interpolatingSpring(stiffness: 170, damping: 2.5))
                        }
                        
                    }
                    else{
                        VStack{
                            Text("Loading...").padding(.bottom,20)
                            ProgressView()
                                      .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}
