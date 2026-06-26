import SwiftUI

/// Menu-bar-only app (LSUIElement). The controller starts its scan loop on init;
/// the menu and the native Settings scene both share that one controller.
@main
struct SeshatApp: App {
    @StateObject private var controller = WatcherController()

    var body: some Scene {
        MenuBarExtra("Seshat", systemImage: "waveform") {
            StatusMenu(controller: controller)
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView(controller: controller)
        }
    }
}
