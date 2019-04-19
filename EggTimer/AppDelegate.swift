//
//  AppDelegate.swift
//  EggTimer
//
//  Created by Tyler Evans on 12/18/18.
//  Copyright © 2018 Tyler Evans. All rights reserved.
//

import Cocoa
import Quartz
import CoreGraphics

import Foundation

func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    if [.keyDown , .flagsChanged].contains(type) {
        var keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        if keyCode == 0 {
            keyCode = 6
        } else if keyCode == 6 {
            keyCode = 0
        }
        event.setIntegerValueField(.keyboardEventKeycode, value: keyCode)
    }
    return Unmanaged.passRetained(event)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    @IBOutlet weak var startTimerMenuItem: NSMenuItem!
    @IBOutlet weak var stopTimerMenuItem: NSMenuItem!
    @IBOutlet weak var resetTimerMenuItem: NSMenuItem!
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        enableMenus(start: true, stop: false, reset: false)
        
        let eventKeyDownMask = (1 << CGEventType.keyDown.rawValue)
        guard CGEvent.tapCreate(tap: .cgSessionEventTap,
                                place: .headInsertEventTap,
                                options: .listenOnly,
                                eventsOfInterest: CGEventMask(eventKeyDownMask),
                                callback: myCGEventCallback,
                                userInfo: nil) != nil else {
                                    let alert = NSAlert()
                                    alert.messageText = "Accessiblity not properly set."
                                    alert.informativeText = "Please give Blueberry accessibility access under 'System Preferences' -> 'Security & Privacy' -> 'Privacy' -> 'Accessibility' and run Blueberry again."
                                    alert.alertStyle = .critical
                                    
                                    alert.addButton(withTitle: "OK")
                                    
                                    alert.runModal()
                                    exit(1)
        }
        
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                               place: .headInsertEventTap,
                                               options: .listenOnly,
                                               eventsOfInterest: CGEventMask(eventMask),
                                               callback: myCGEventCallback,
                                               userInfo: nil) else {
                                                print("failed to create event tap")
                                                exit(1)
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    func enableMenus(start: Bool, stop: Bool, reset: Bool) {
        startTimerMenuItem.isEnabled = start
        stopTimerMenuItem.isEnabled = stop
        resetTimerMenuItem.isEnabled = reset
    }
    
}

