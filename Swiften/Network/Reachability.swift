//
//  Reachability.swift
//  Swiften
//
//  Created by Cator Vee on 5/25/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import SystemConfiguration
import Foundation

func reachabilityCallback(_ reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer) {
    let reachability = Unmanaged<Reachability>.fromOpaque(UnsafeRawPointer(info)).takeUnretainedValue()
    DispatchQueue.main.async {
        reachability.reachabilityChanged(flags)
    }
}

open class Reachability: CustomStringConvertible {

    public typealias NetworkReachable = (Reachability) -> ()
    public typealias NetworkUnreachable = (Reachability) -> ()

    public enum NetworkStatus: CustomStringConvertible {

        case notReachable, reachableViaWiFi, reachableViaWWAN

        public var description: String {
            switch self {
            case .reachableViaWWAN:
                return "WWAN"
            case .reachableViaWiFi:
                return "WiFi"
            case .notReachable:
                return "NoConnection"
            }
        }
    }

    // MARK: - Properties
    
    open var reachableOnWWAN: Bool
    
    open var currentReachabilityStatus: NetworkStatus {
        if isReachable() {
            if isReachableViaWiFi() {
                return .reachableViaWiFi
            }
            if isRunningOnDevice {
                return .reachableViaWWAN
            }
        }
        return .notReachable
    }

    fileprivate var reachabilityFlags: SCNetworkReachabilityFlags {
        guard let reachabilityRef = reachabilityRef else { return SCNetworkReachabilityFlags() }

        var flags = SCNetworkReachabilityFlags()
        let gotFlags = withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
        }

        if gotFlags {
            return flags
        } else {
            return SCNetworkReachabilityFlags()
        }
    }

    fileprivate let isRunningOnDevice: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
        #else
            return true
        #endif
    }()

    fileprivate var notifierRunning = false
    fileprivate var reachabilityRef: SCNetworkReachability?
    fileprivate var previousFlags: SCNetworkReachabilityFlags?
    
    // MARK: - Statics
    
    open static var networkStatus: NetworkStatus {
        return Reachability.reachabilityForInternetConnection()?.currentReachabilityStatus ?? .notReachable
    }
    
    open static func isReachable() -> Bool {
        return Reachability.reachabilityForInternetConnection()?.isReachable() == true
    }
    
    open static func isReachableViaWWAN() -> Bool {
        return Reachability.reachabilityForInternetConnection()?.isReachableViaWWAN() == true
    }
    
    open static func isReachableViaWiFi() -> Bool {
        return Reachability.reachabilityForInternetConnection()?.isReachableViaWiFi() == true
    }

    // MARK: - Initialisation methods

    required public init(reachabilityRef: SCNetworkReachability) {
        reachableOnWWAN = true
        self.reachabilityRef = reachabilityRef
    }

    public convenience init?(hostname: String) {
        let nodename = (hostname as NSString).utf8String
        guard let ref = SCNetworkReachabilityCreateWithName(nil, nodename!) else { return nil }
        self.init(reachabilityRef: ref)
    }

    open class func reachabilityForInternetConnection() -> Reachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let ref = withUnsafePointer(to: &zeroAddress, {$0.withMemoryRebound(to: sockaddr.self, capacity: 1, {SCNetworkReachabilityCreateWithAddress(nil, $0)})}) else {
            return nil
        }
        return Reachability(reachabilityRef: ref)
    }

    // MARK: - Notifier methods
    
    open func startNotifier() -> Bool {
        guard !notifierRunning else { return true }
        guard let reachabilityRef = reachabilityRef else { return false }

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        if SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback as? SCNetworkReachabilityCallBack, &context) {
            if SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) {
                notifierRunning = true
                return true
            }
        }

        stopNotifier()
        return false
    }

    open func stopNotifier() {
        defer { notifierRunning = false }
        guard let reachabilityRef = reachabilityRef else { return }
        SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue);
    }

    // MARK: - Connection test methods
    
    open func isReachable() -> Bool {
        let flags = reachabilityFlags
        return isReachableWithFlags(flags)
    }

    open func isReachableViaWWAN() -> Bool {
        let flags = reachabilityFlags
        
        // Check we're not on the simulator, we're REACHABLE and check we're on WWAN
        return isRunningOnDevice && isReachable(flags) && isOnWWAN(flags)
    }

    open func isReachableViaWiFi() -> Bool {
        let flags = reachabilityFlags
        
        // Check we're reachable
        if !isReachable(flags) {
            return false
        }

        // Must be on WiFi if reachable but not on an iOS device (i.e. simulator)
        if !isRunningOnDevice {
            return true
        }

        // Check we're NOT on WWAN
        return !isOnWWAN(flags)
    }

    // MARK: - *** Private methods ***
    fileprivate func reachabilityChanged(_ flags: SCNetworkReachabilityFlags) {
        guard previousFlags != flags else { return }

        Log.info("Reachability: \(string(forFlags: flags))")
        Notifications.reachabilityChanged.post(self)

        previousFlags = flags
    }

    fileprivate func isReachableWithFlags(_ flags: SCNetworkReachabilityFlags) -> Bool {

        if !isReachable(flags) {
            return false
        }

        if isConnectionRequiredOrTransient(flags) {
            return false
        }

        if isRunningOnDevice {
            if isOnWWAN(flags) && !reachableOnWWAN {
                // We don't want to connect when on 3G.
                return false
            }
        }

        return true
    }

    // WWAN may be available, but not active until a connection has been established.
    // WiFi may require a connection for VPN on Demand.
    fileprivate func isConnectionRequired() -> Bool {
        return connectionRequired()
    }

    fileprivate func connectionRequired() -> Bool {
        let flags = reachabilityFlags
        return isConnectionRequired(flags)
    }

    // Dynamic, on demand connection?
    fileprivate func isConnectionOnDemand() -> Bool {
        let flags = reachabilityFlags
        return isConnectionRequired(flags) && isConnectionOnTrafficOrDemand(flags)
    }

    // Is user intervention required?
    fileprivate func isInterventionRequired() -> Bool {
        let flags = reachabilityFlags
        return isConnectionRequired(flags) && isInterventionRequired(flags)
    }

    fileprivate func isOnWWAN(_ flags: SCNetworkReachabilityFlags) -> Bool {
        #if os(iOS)
            return flags.contains(.isWWAN)
        #else
            return false
        #endif
    }
    fileprivate func isReachable(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.reachable)
    }
    fileprivate func isConnectionRequired(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionRequired)
    }
    fileprivate func isInterventionRequired(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.interventionRequired)
    }
    fileprivate func isConnectionOnTraffic(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionOnTraffic)
    }
    fileprivate func isConnectionOnDemand(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionOnDemand)
    }
    func isConnectionOnTrafficOrDemand(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return !flags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    fileprivate func isTransientConnection(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.transientConnection)
    }
    fileprivate func isLocalAddress(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.isLocalAddress)
    }
    fileprivate func isDirect(_ flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.isDirect)
    }
    fileprivate func isConnectionRequiredOrTransient(_ flags: SCNetworkReachabilityFlags) -> Bool {
        let testcase: SCNetworkReachabilityFlags = [.connectionRequired, .transientConnection]
        return flags.intersection(testcase) == testcase
    }

    fileprivate func string(forFlags flags: SCNetworkReachabilityFlags) -> String {
        var W: String
        if isRunningOnDevice {
            W = isOnWWAN(flags) ? "W" : "-"
        } else {
            W = "X"
        }
        let R = isReachable(flags) ? "R" : "-"
        let c = isConnectionRequired(flags) ? "c" : "-"
        let t = isTransientConnection(flags) ? "t" : "-"
        let i = isInterventionRequired(flags) ? "i" : "-"
        let C = isConnectionOnTraffic(flags) ? "C" : "-"
        let D = isConnectionOnDemand(flags) ? "D" : "-"
        let l = isLocalAddress(flags) ? "l" : "-"
        let d = isDirect(flags) ? "d" : "-"

        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }

    open var description: String {
        return string(forFlags: reachabilityFlags)
    }

    deinit {
        stopNotifier()
        reachabilityRef = nil
    }
}
