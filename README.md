# NotificationView
A Swift package to elegantly ask for notification permissions just like Apple's apps.

## Screenshots
![Simulator Screenshot - iPhone 16 Pro 2 - 2024-10-03 at 16 37 46-portrait](https://github.com/user-attachments/assets/475d6480-c400-48b3-83bf-2b379d36c455)
![Simulator Screenshot - iPhone 16 Pro 2 - 2024-10-03 at 16 37 52-portrait](https://github.com/user-attachments/assets/56fc62ca-5bde-43b6-a56e-112d9b5feb88)


## Installation
### Swift Package Manager

Add https://github.com/FPST-08/NotificationView in the [“Swift Package Manager” tab in Xcode]("https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app").

## Usage

There are two ways to use. The `NotifcationView` accepts a closure for the button and can be presented in other ways like Onboardings. On the other hand the modifier handles that for you and it just has to be presented.

## Using the Modifier

`.notificationView` requires a title, subtitle, and a boolean binding to control when the notification view is presented from a parent view.

### Initialization

```swift
init(
    isPresented: Binding<Bool>, // A binding to control when the notification view is presented from a parent view
    title: String, // A short, descriptive title like "Stay Motivated with Fitness Notifications"
    subTitle: String, // A longer description of your notifications
    notificationCenterOptions: UNAuthorizationOptions // The notification options you want to request (e.g. .alert, .badge, .sound)
)
```

### Example
```swift
import SwiftUI
import NotificationView

struct ContentView: View {
    @State private var showNotificationView = false
    var body: some View {
        Button("Enable Notifications") {
            showNotificationView.toggle()
        }
        .notificationView(
            isPresented: $showNotificationView, 
            title: "Stay Motivated with Fitness Notifications", 
            subTitle: "Notifications can help you close your rings, cheer on your friends, and see what's new with Fitness+.", 
            notificationCenterOptions: [.alert, .badge, .sound]
        )
    }
}
```

### Navigation & UserNotifications
The modifier will automatically handle requesting permissions and navigation, dismissing itself when permissions are granted, not allowed, or an error occurs.

## Using the View directly

`NotificationView' requires a title, subtitle and a closure. Optionally a buttonTitle can be provided.

### Initialization
```swift
init(
title: String, //  A short, descriptive title like "Stay Motivated with Fitness Notifications"
subTitle: String,  // A longer description of your notifications
buttonTitle: String = "Continue", // The text presented on the button like "Continue" or "Okay".
action: @escaping () async -> Void // The closure that is run when the button was pressed. Dismissing or navigation needs to be handled from there
)
```
### Example
```swift
struct ContentView: View {
     @State private var isPresented = false
     var body: some View {
         Button("Show sheet") {
             isPresented.toggle()
         }
         .fullScreenCover(isPresented: $isPresented) {
             NotificationView(title: "Stay Motivated with Fitness Notifications", subTitle: "Notifications can help you close your rings, cheer on your friends, and see what's new with Fitness+", buttonTitle: "Continue") {
                 let auth = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                 isPresented = false
             }
         }
     }
 }
```

### Navigation & UserNotifications
The view will not handle requesting permissions or navigation. Both has to be done from the closure you pass in. If you want to use this view in your Onboarding or in a Sequence with other Views, using NotificationView directly is the better option

## Contributors

<a href="https://github.com/FPST-08/NotificationView/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=FPST-08/NotificationView" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

## License
`NotificationView` is available under the MIT license. See the LICENSE file for more info.
