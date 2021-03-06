//
//  AutoPollingType2TagResponse.swift
//  TappyBLE
//
//  Created by Alice Cai on 2019-08-08.
//  Copyright © 2019 TapTrack. All rights reserved.
//

import Foundation


import Foundation


@objc public protocol AutoPollingType2TagResponse {
    
    @objc var commandFamily: [UInt8] { get }
    @objc var commandCode: UInt8 { get }
    @objc var tagType: UInt8 { get }
    
    @objc var sensRes: [UInt8] { get }
    @objc var selRes: UInt8 { get }
    @objc var uid: [UInt8] { get }
    
    @objc init(tagMetadata: [UInt8]) throws
}

public extension AutoPollingType2TagResponse {
    func parseTagMetadata(metadata: [UInt8]) throws -> ([UInt8], UInt8, [UInt8]) {
        guard metadata.count > 4 else {
            throw TCMPParsingError.payloadTooShort
        }
        
        let sensRes: [UInt8] = Array(metadata[0...1])
        let selRes: UInt8 = metadata[2]
        
        let uidLength: Int = Int(metadata[3])
        let uid: [UInt8] = Array(metadata[4..<(4 + uidLength)])
        
        return (sensRes, selRes, uid)
    }
}
