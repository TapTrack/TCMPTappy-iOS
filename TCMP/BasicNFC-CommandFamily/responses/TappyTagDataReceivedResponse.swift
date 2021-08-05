//
//  TappyTagDataReceivedResponse.swift
//  TapTrackReader
//
//  Created by David Shalaby on 2021-06-07.
//  Copyright © 2021 David Shalaby. All rights reserved.
//
/*
 * Copyright (c) 2021. Papyrus Electronics, Inc d/b/a TapTrack.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * you may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import SwiftTLV

@objc public class TappyTagDataReceivedResponse : NSObject, TCMPMessage {
    
    @objc public private(set) var rawTlvs : [UInt8] = []
    @objc public private(set) var dataReceived : [UInt8] = []
    
    @objc public let commandFamily: [UInt8] = CommandFamily.basicNFC
    
    @objc public let commandCode: UInt8 = BasicNFCResponseCode.tappyTagDataReceived.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            return rawTlvs
        }
    }
    
    @objc public init(payload: [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        var tlvs : [TLV]
        tlvs = try parseTlvByteArray(tlvByteArray: payload)        
        rawTlvs = payload
        dataReceived = fetchTlvValue(tagToFetch: TCMPTlvTag.tappyTagInitialHandshakeData.rawValue, from: tlvs)
 
    }
}
