//
//  MultipeerHandler.swift
//  RTStvOS
//
//  Created by João Henrique Andrade on 03/07/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public protocol MultipeerHandler {
    func receivedData(_ data: Data, from peerID: MCPeerID)
    func receivedStream(_ stream: InputStream, from peerID: MCPeerID)
    func startedReceivingResource(_ resourceName: String, from peerID: MCPeerID)
    func finishedReceivingResource(_ resourceName: String, from peerID: MCPeerID, answer: ResourceAnswer)
    func peerConnecting(_ id: MCPeerID)
    func peerJoined(_ id: MCPeerID)
    func peerLeft(_ id: MCPeerID)

    #if os(iOS)
    func peerDiscovered(_ id: MCPeerID) -> Bool
    func peerLost(_ id: MCPeerID)
    #else
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool
    #endif
}

public enum ResourceAnswer {
    case success(at: URL)
    case fail(err: Error)
}

public extension MultipeerHandler {
    func receivedData(_ data: Data, from peerID: MCPeerID) { }
    func receivedStream(_ stream: InputStream, from peerID: MCPeerID) { }
    func startedReceivingResource(_ resourceName: String, from peerID: MCPeerID) { }
    func finishedReceivingResource(_ resourceName: String, from peerID: MCPeerID, answer: ResourceAnswer) { }
    func peerJoined(_ id: MCPeerID) { }
    func peerConnecting(_ id: MCPeerID) { }
    func peerLeft(_ id: MCPeerID) { }
}
