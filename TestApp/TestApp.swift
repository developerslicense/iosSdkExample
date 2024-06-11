//
//  TestAppApp.swift
//  TestApp
//
//  Created by Mikhail Belikov on 13.09.2023.
//

import SwiftUI
import AirbaPay

class AppDelegate1: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    return true
  }
}

@main
struct TestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate1.self) var delegate

    init() {
        AirbaPayFonts.registerCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ExamplePage()
        }
    }
}
