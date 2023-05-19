//
//  ManageOurIncomeApp.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 08/05/23.
//

import SwiftUI

@main
struct ManageOurIncomeApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView().environment(\.colorScheme, .light)
        }
    }
}
