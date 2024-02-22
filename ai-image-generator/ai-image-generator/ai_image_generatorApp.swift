//
//  ai_image_generatorApp.swift
//  ai-image-generator
//
//  Created by Harry Witcomb on 22/02/2024.
//

import SwiftUI
import SwiftOpenAI


@main
struct ai_image_generatorApp: App {

    var body: some Scene {

        WindowGroup {
            HomeView(service: OpenAIServiceFactory.service(apiKey: "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"))
        }
    }
}
