//
//  ContentView.swift
//  ai-image-generator
//
//  Created by Harry Witcomb on 22/02/2024.
//

import SwiftUI
import SwiftOpenAI
import GoogleMobileAds

let bannerTestID = "ca-app-pub-3940256099942544/2934735716"
let intersitialTestID = "ca-app-pub-3940256099942544/4411468910"

struct HomeView: View {
    
    
    
    private let coordinator = IntersitialAdCoordinator()
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    
    @State private var imageProvider: ImageProvider
    
    @State private var isLoading = false
    
    @State private var imagePrompt = ""
    @State private var imageEditPrompt = ""
    
    @State private var errorMessage = ""
    @State private var editImageAlertShown = false
        
    @State private var imageCreateCount = 0
    
    @State private var displayedImage = UIImage()
    
    
        
    let testImageURL = "https://oaidalleapiprodscus.blob.core.windows.net/private/org-vBsShdpfty1vqph8rhkyD7LE/user-8Tl0ByUvLWJixkQPAQLGoAKL/img-ugCYbXoOqU0WojXOYzcyni0q.png?st=2024-02-27T12%3A37%3A18Z&se=2024-02-27T14%3A37%3A18Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-02-27T06%3A42%3A56Z&ske=2024-02-28T06%3A42%3A56Z&sks=b&skv=2021-08-06&sig=bP3P3O41vUgOV7zAn25ugd3npjmRvWngTwXzPDkaU7I%3D"
    
    //var service: OpenAIService
    
    init(service: OpenAIService) {
        _imageProvider = State(initialValue: ImageProvider(service: service))
    }
    
    var adViewControllerRepresentableView: some View {
        adViewControllerRepresentable
            .frame(width: .zero, height: .zero)
    }
    
    var body: some View {
        
        
        ScrollView{
            
            HStack{
                TextField("Enter an Image Prompt", text: $imagePrompt)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).strokeBorder(.gray))
                Button(
                    action: {
                        imageCreateCount += 1
                        print(imageCreateCount)
                        if imageCreateCount >= 5 {
                            coordinator.showAd(from: adViewControllerRepresentable.viewController)
                            print(imageCreateCount)
                            imageCreateCount = 0
                        }
                        //createImage()
                    }, label: {
                   Image(systemName: "photo.badge.plus.fill")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                })
                .background(adViewControllerRepresentableView)

            }
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .bold()
            }
            if isLoading {
                ProgressView()
            } else {
                AsyncImage(url: URL(string: testImageURL) , scale: 1) { image in
                    image.image?.resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.gray))

                    
                }
                ForEach(Array(imageProvider.images.enumerated()), id: \.offset) { _, url in
                    AsyncImage(url: url , scale: 1) { image in
                        image.image?.resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 5.0))
                    }
                }
                if imageProvider.images.count > 0 {
                    HStack{
                        Group{
                            Button(
                                action: {
                                    editImageAlertShown = true
                                    editImage()
                                }, label: {
                                Text("Edit Image")
                            })
                            Button(
                                action: {
                                    
                                }, label: {
                                Text("Create Variations")
                            })
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        
                    }
                }
                
            }
           
        }
        .onAppear{
            coordinator.loadAd()
        }
        .padding()
        Spacer()
        AdBannerView(adUnitID: bannerTestID).frame(height: 50)
    }
    
    func createImage(){
        Task {
            do {
                isLoading = true
                try await imageProvider.createImage(parameters: .init(prompt: imagePrompt, model: .dalle2(.large)))
                isLoading = false
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
    
    func editImage(){
        Task {
            do {
                isLoading = true
                if let data = try? Data(contentsOf: imageProvider.images[0]) {
                    displayedImage = UIImage(data: data)!
                }
                
                try await imageProvider.editImage(parameters: .init(image: displayedImage, prompt: imageEditPrompt))
                isLoading = false
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
    
    func createImageVariations(){
        Task {
            do {
                isLoading = true
                if let data = try? Data(contentsOf: imageProvider.images[0]) {
                    displayedImage = UIImage(data: data)!
                }
                try await imageProvider.createImageVariations(parameters: .init(image: displayedImage))
                isLoading = false
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
    
    
    
}

struct AdBannerView: UIViewRepresentable {
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        
    }
    
    let adUnitID: String
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeFromCGSize(CGSize(width: 320, height: 50)))
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.load(GADRequest())
        return bannerView
    }
}

private struct AdViewControllerRepresentable: UIViewControllerRepresentable {
    
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

private class IntersitialAdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var intersitial: GADInterstitialAd?
    
    func loadAd(){
        GADInterstitialAd.load(withAdUnitID: intersitialTestID, request: GADRequest()) { ad, _ in
            self.intersitial = ad
            self.intersitial?.fullScreenContentDelegate = self
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        intersitial = nil
    }
    
    func showAd( from viewController: UIViewController) {
        guard let intersitial = intersitial else {
            return print("Ad not ready")
        }
        
        intersitial.present(fromRootViewController: viewController)
    }
}

