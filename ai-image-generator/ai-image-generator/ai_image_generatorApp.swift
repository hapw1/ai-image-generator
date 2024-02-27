//
//  ai_image_generatorApp.swift
//  ai-image-generator
//
//  Created by Harry Witcomb on 22/02/2024.
//

import SwiftUI
import SwiftOpenAI
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Can also put this inside init() if you don't want to create an AppDelegate
    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }

}



@main
struct ai_image_generatorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {

        WindowGroup {
            HomeView(service: OpenAIServiceFactory.service(apiKey: "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"))
        }
    }
}
