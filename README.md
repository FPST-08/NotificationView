# NotificationView
A swift package to elegantly ask for notification permissions just like apple apps

![Simulator Screenshot - iPhone 16 Pro 2 - 2024-10-03 at 16 37 46-portrait](https://github.com/user-attachments/assets/475d6480-c400-48b3-83bf-2b379d36c455)

![Simulator Screenshot - iPhone 16 Pro 2 - 2024-10-03 at 16 37 52-portrait](https://github.com/user-attachments/assets/56fc62ca-5bde-43b6-a56e-112d9b5feb88)


## Installation
### Swift Package Manager

Install this package by Xcode -> File -> Add Package Dependencies... -> Paste https://github.com/FPST-08/NotificationView in top right search bar -> Add Package



## Usage

`NotificationView` can be used anywhere in your app. You need to provide an Ìmage, primaryTitle, secondaryTitle and an asynchronous closure. 

### Initialization

```swift
 public init(
image: Image, // This should be your app icon
primaryTitle: String, // This should be a short, descriptive title like "Stay Motivated with Fitness Notifications"
secondaryTitle: String, // This can be a longer description of your notifications
buttonTitle: String = "Continue", // The text of the button
action: @escaping () async -> Void // A closure that asks for permission and furthermore handles navigation
)
```

### Navigation
Dismissing or continuing your onboarding needs to be handled by the closure you provide. 

## Example code
```swift
struct ContentView: View {
    @State private var isPresented = false
    var body: some View {
        Button("Show sheet") {
            isPresented.toggle()
        }
        .fullScreenCover(isPresented: $isPresented) {
            NotificationView(image: Image(.appIcon), primaryTitle: "Stay Motivated with Fitness Notifications", secondaryTitle: "Notifications can help you close your rings, cheer on your friends, and see what's new with Fitness+") {
                let auth = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                isPresented = false
            }
        }
    }
}
```

## License
`NotificationView` is available under the MIT license. See the LICENSE file for more info.
