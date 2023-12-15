//
//  NetworkSingleton.swift
//  KwiksSystemsAlerts
//
//  Created by Charlie Arcodia on 3/27/23.
//

import Foundation
import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(ServiceKit().handleServiceSatisified), object: nil)
                }
            } else if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(ServiceKit().handleServiceUnsatisified), object: nil)
                }
            } else if path.status == .requiresConnection {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(ServiceKit().handleServiceUnsatisified), object: nil)
                }
            } else {
                debugPrint("case should not hit - check me in the network monitor extension")
            }
            debugPrint(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: ServiceKit().networkMonitor)
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
