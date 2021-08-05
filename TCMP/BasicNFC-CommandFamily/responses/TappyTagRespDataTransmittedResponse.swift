//
//  TappyTagResponseDataTransmitted.swift
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

@objc public class TappyTagRespDataTransmittedResponse : NSObject, TCMPMessage {
    @objc public private(set) var rawTlvs : [UInt8] = []
    @objc public private(set) var dataOffset : UInt32
    @objc public private(set) var dataLength : UInt32
    
    @objc public let commandFamily: [UInt8] = CommandFamily.basicNFC
    
    @objc public let commandCode: UInt8 = BasicNFCResponseCode.tappyTagResponseDataTransmitted.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            return rawTlvs
        }
    }
    
    @objc private override init(){
        dataOffset = 0
        dataLength = 0
    }
    
    @objc public init(payload: [UInt8]) throws {
        dataOffset = 0
        dataLength = 0
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        var tlvs : [TLV]
        tlvs = try parseTlvByteArray(tlvByteArray: payload)
        rawTlvs = payload
        
        let offsetValue : [UInt8] = fetchTlvValue(tagToFetch: TCMPTlvTag.tappyTagResponseDataAckOffset.rawValue, from: tlvs)
        if (offsetValue.count == 1 || offsetValue.count == 2 || offsetValue.count == 4){
            dataOffset = try ByteUtils.bytesToUInt(bytes: offsetValue)
        }
        
        let lengthValue : [UInt8] = fetchTlvValue(tagToFetch: TCMPTlvTag.tappyTagResponseDataAckLength.rawValue, from: tlvs)
        if (lengthValue.count == 1 || lengthValue.count == 2 || lengthValue.count == 4){
            dataLength = try ByteUtils.bytesToUInt(bytes: offsetValue)
        }
                
    }
}
