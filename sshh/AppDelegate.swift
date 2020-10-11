import Cocoa
import SwiftUI
import AudioToolbox
import AVKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let appState = AppState()
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView().environmentObject(appState.contentViewModel)

        popover.contentSize = NSSize(width: 440, height: 360)
        popover.contentViewController = NSHostingController(rootView: contentView)
        statusBar = StatusBarController.init(popover)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

