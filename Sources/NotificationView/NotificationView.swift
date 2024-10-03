// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// The NotificationView used to ask for permission
public struct NotificationView: View {
    
    /// The image of the notification
    let image: Image
    
    
    /// The primary title of the usage description
    let primaryTitle: String
    
    
    /// The secondary title of the usage description
    let secondaryTitle: String
    
    
    /// The title for the button
    let buttonTitle: String
    
    
    /// An action that is invoked by a button press
    let action: () async -> Void
    
    
    /// Indicating a currently running action block after a button press
    @State private var loading = false
    
    /// The gradient used for the phone dummy
    let gradient = LinearGradient(colors: [Color(UIColor(red: 41/256, green: 41/256, blue: 41/256, alpha: 1)), Color(UIColor(red: 55/256, green: 55/256, blue: 55/256, alpha: 1))], startPoint: .top, endPoint: .bottom)
    
    /// The color used as placeholder in the notification
    let blankColor = Color(UIColor(red: 126/256, green: 126/256, blue: 131/256, alpha: 1))
    
    /// The background behind the phone dummy
    let bgGradient = LinearGradient(colors: [Color.black, Color(UIColor(red: 21/256, green: 21/256, blue: 21/256, alpha: 1))], startPoint: .top, endPoint: .bottom)
    
    public var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                bgGradient.ignoresSafeArea()
                ZStack {
                    UnevenRoundedRectangle(topLeadingRadius: 40, topTrailingRadius: 40)
                        .foregroundStyle(gradient)
                        .padding(.top, 35)
                        .padding(.horizontal, 45)
                    VStack {
                        Text("09:41")
                            .monospacedDigit()
                            .foregroundStyle(Color(UIColor(red: 159/256, green: 160/256, blue: 164/256, alpha: 1)))
                            .font(.system(size: 65, weight: .light))
                            .padding(.top, 35)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color(UIColor(red: 79/256, green: 80/256, blue: 81/256, alpha: 1)))
                                
                            HStack {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(10)
                                    .padding(.leading, 10)
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundStyle(blankColor)
                                        .frame(width: 80, height: 13)
                                    RoundedRectangle(cornerRadius: 2)
                                        .foregroundStyle(blankColor)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 7)
                                    RoundedRectangle(cornerRadius: 2)
                                        .foregroundStyle(blankColor)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 7)
                                }
                                .padding(.trailing, 20)
                            }
                        }
                        .frame(width: 275, height: 70)
                        .padding(.top, -5)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            ZStack {
                Color(UIColor(red: 28/256, green: 28/256, blue: 30/256, alpha: 1))
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text(primaryTitle)
                        .font(.largeTitle.bold())
                        .padding(.top, 30)
                        .multilineTextAlignment(.center)
                    Text(secondaryTitle)
                        .font(.body)
                        .foregroundStyle(Color.secondary)
                        .multilineTextAlignment(.center)
                        
                    
                    Spacer()
                    
                    Button {
                        Task {
                            loading = true
                            await action()
                            loading = false
                        }
                    } label: {
                        Text(buttonTitle)
                    }
                    .buttonStyle(PrimaryButtonStyle(loading: loading))
                    .padding(.bottom, 56)
                    .disabled(loading)
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity)
            .padding(.top, -14)
        }
        .colorScheme(.dark)
    }
    
    public init(image: Image, primaryTitle: String, secondaryTitle: String, buttonTitle: String = "Continue", action: @escaping () async -> Void) {
        self.image = image
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.action = action
        self.buttonTitle = buttonTitle
    }
    
}



struct PrimaryButtonStyle: ButtonStyle {
    let loading: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        Group {
            HStack {
                Spacer()
                
                if !loading {
                    configuration
                        .label
                        .font(.headline.weight(.semibold))
                        .padding(.vertical)
                } else {
                    ProgressView()
                        .font(.headline.weight(.semibold))
                        .padding(.vertical)
                }
                
                Spacer()
            }
        }
        .foregroundColor(.white)
        .background(loading ? .gray : Color(UIColor(red: 44/256, green: 44/256, blue: 46/256, alpha: 1)))
        .cornerRadius(14)
        .opacity(loading || configuration.isPressed ? 0.5 : 1)
        .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
