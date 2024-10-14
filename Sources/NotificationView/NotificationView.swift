// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Foundation

/// The NotificationView used to ask for permission
public struct NotificationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    
    func appIcon(in bundle: Bundle = .main) -> String? {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let iconFileName = iconFiles.last else {
            return nil
        }
        
        return iconFileName
    }
    
    /// The primary title of the usage description
    let title: String
    
    
    /// The secondary title of the usage description
    let subTitle: String
    
    
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
                                if let image = appIcon(), let uiImage = UIImage(named: image) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45, height: 45)
                                        .cornerRadius(10)
                                        .padding(.leading, 10)
                                        .colorInvert(colorScheme == .light)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 45, height: 45)
                                        .padding(.leading, 10)
                                        .foregroundStyle(.gray)
                                }
                                    
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
                .accessibilityHidden(true)
            }
            .frame(maxHeight: .infinity)
            ZStack {
                Color(UIColor(red: 28/256, green: 28/256, blue: 30/256, alpha: 1))
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
                VStack(spacing: 20) {
                    Text(title)
                        .font(.largeTitle.bold())
                        .padding(.top, 30)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel(title)
                        .dynamicTypeSize(.large)
                    Text(subTitle)
                        .font(.body)
                        .foregroundStyle(Color.secondary)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel(subTitle)
                        .dynamicTypeSize(.medium)
                    
                    
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
                    .accessibilityLabel(buttonTitle)
                    .padding(.bottom, 56)
                    .disabled(loading)
                }
                .padding(.horizontal, 30)
            }
            .frame(maxHeight: .infinity)
            .padding(.top, -14)
        }
        .colorScheme(.dark)
        .colorInvert(colorScheme == .light)
    }
    
    public init(title: String, subTitle: String, buttonTitle: String = "Continue", action: @escaping () async -> Void) {
        self.title = title
        self.subTitle = subTitle
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
        .opacity(loading || configuration.isPressed ? 0.5 : 1)
        .opacity(configuration.isPressed ? 0.5 : 1)
        .accessibilitySortPriority(1)
        .accessibilityElement(children: .combine)
        .accessibilityHint(loading ? Text("Button is disabled while loading") : Text("Tap to activate"))
        
    }
}

struct NotificationViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var subTitle: String
    var notificationCenterOptions: UNAuthorizationOptions
    
    init(isPresented: Binding<Bool>, title: String, subTitle: String, notificationCenterOptions: UNAuthorizationOptions) {
        self._isPresented = isPresented
        self.title = title
        self.subTitle = subTitle
        self.notificationCenterOptions = notificationCenterOptions
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                NotificationView(title: title, subTitle: subTitle) {
                    do {
                        try await UNUserNotificationCenter.current().requestAuthorization(options: notificationCenterOptions)
                        isPresented = false
                    } catch {
                        isPresented = false
                    }
                    
                }
            }
    }
}

public extension View {
    func notificationView(isPresented: Binding<Bool>, title: String, subTitle: String, notificationCenterOptions: UNAuthorizationOptions) -> some View {
        modifier(NotificationViewModifier(isPresented: isPresented, title: title, subTitle: subTitle, notificationCenterOptions: notificationCenterOptions))
    }
}


extension View {
    /// Inverts the colors of this view if boolean is true
    /// - Parameter bool: The bool to toggle the invert
    /// - Returns: A view that inverts its colors.
    func colorInvert(_ bool: Bool) -> some View {
        modifier(ColorInvertViewModifier(bool: bool))
    }
}

/// A view modifier that inverts the colors of a view
struct ColorInvertViewModifier: ViewModifier {
    let bool: Bool
    func body(content: Content) -> some View {
        if bool {
            content
                .colorInvert()
        } else {
            content
        }
    }
}
