import AppKit

class StatusBarController {
    // private var statusBar: NSStatusBar
    private var popover: NSPopover
    
    let statusItem = NSStatusBar.system.statusItem(withLength: 30)
    
    init(_ popover: NSPopover) {
        self.popover = popover
                
        if let statusBarButton = statusItem.button {
            
            statusBarButton.isBordered = true
            statusBarButton.image = #imageLiteral(resourceName: "Mute")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            
            statusBarButton.action = #selector(self.togglePopover(sender:))
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }
}
