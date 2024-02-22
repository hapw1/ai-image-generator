//
//  ContentView.swift
//  ai-image-generator
//
//  Created by Harry Witcomb on 22/02/2024.
//

import SwiftUI
import SwiftOpenAI


struct HomeView: View {
    
    @State private var imageProvider: ImageProvider
    @State private var isLoading = false
    @State private var imagePrompt = ""
    @State private var errorMessage = ""
        
    let testImageURL = "https://oaidalleapiprodscus.blob.core.windows.net/private/org-vBsShdpfty1vqph8rhkyD7LE/user-8Tl0ByUvLWJixkQPAQLGoAKL/img-peeERIUZhnvxWljTNAGM5WwG.png?st=2024-02-22T20%3A33%3A13Z&se=2024-02-22T22%3A33%3A13Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-02-22T15%3A29%3A37Z&ske=2024-02-23T15%3A29%3A37Z&sks=b&skv=2021-08-06&sig=KRoQdBlpvmGwC9NFtZHNpaE4u2r3LEO5A5B767xtzB8%3D"
    
    //var service: OpenAIService
    
    init(service: OpenAIService) {
        _imageProvider = State(initialValue: ImageProvider(service: service))
    }
    
    var body: some View {
        
        
        ScrollView{
            TextField("Enter an Image Prompt", text: $imagePrompt)
                .padding()
                .border(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
            Button("Generate Image", action: {
                Task {
                    do {
                        isLoading = true
                        try await imageProvider.createImage(parameters: .init(prompt: imagePrompt, model: .dalle3(.largeSquare)))
                        isLoading = false
                    } catch {
                        errorMessage = "\(error)"
                    }
                }
            } )
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .bold()
            }
            if isLoading {
                ProgressView()
            } else {
                //AsyncImage(url: URL(string: testImageURL) , scale: 1) { image in
                //    image.image?.resizable()
                //        .scaledToFit()
                //        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
                //}
                ForEach(Array(imageProvider.images.enumerated()), id: \.offset) { _, url in
                    AsyncImage(url: url , scale: 1) { image in
                        image.image?.resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
           
        }
        .padding()
    }
    
}




