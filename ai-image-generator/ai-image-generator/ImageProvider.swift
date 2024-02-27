//
//  ImageProvider.swift
//  ai-image-generator
//
//  Created by Harry Witcomb on 22/02/2024.
//

import Foundation
import SwiftOpenAI

@Observable class ImageProvider {
    private let service: OpenAIService
    
    var images: [URL] = []
    
    init(service: OpenAIService) {
        self.service = service
    }
    
    func createImage(parameters: ImageCreateParameters) async throws {
        let urls = try await service.createImages(parameters: parameters).data.map(\.url)
        self.images = urls.compactMap{ $0 }
    }
    
    func editImage(parameters: ImageEditParameters) async throws {
        let urls = try await service.editImage(parameters: parameters).data.map(\.url)
        self.images = urls.compactMap { $0 }
    }
    
    func createImageVariations(parameters: ImageVariationParameters) async throws {
        let urls = try await service.createImageVariations(parameters: parameters).data.map(\.url)
        self.images = urls.compactMap { $0 }
    }
}
