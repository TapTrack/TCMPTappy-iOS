//
//  InitiateTappyTagHandshake.swift
//  TapTrackReader
//
//  Created by David Shalaby on 2021-06-06.
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

@objc public class InitiateTappyTagHandshake: NSObject, TCMPMessage {
    
    @objc public private(set) var rawTlvs : [UInt8] = []
    @objc public private(set) var timeout : UInt8 = 0
    @objc public private(set) var responseData : [UInt8] = []
    @objc public private(set) var customAid : [UInt8] = []
    @objc public private(set) var shouldSwitchToKeyboardMode : Bool = false
    
    @objc public let commandFamily: [UInt8] = CommandFamily.basicNFC
    
    @objc public let commandCode: UInt8 = BasicNFCCommandCode.initiateTappyTagHandshake.rawValue
    
    @objc public var payload: [UInt8] {
        get{
            return rawTlvs
        }
    }
    
    @objc public init(payload: [UInt8]) throws {
        super.init()
        try parsePayload(payload: payload)
    }
    
    @objc public init(timeout: UInt8 = 0, responseData: [UInt8] = [], customAid: [UInt8] = [], shouldSwitchToKeyboardEmulation: Bool = false) throws {
        
        var tlvs : [TLV] = []
        
        if (timeout != 0){
            tlvs.append(try TLV(typeVal: TCMPTlvTag.pollingTimeout.rawValue, value: [timeout]))
            self.timeout = timeout
        }
        
        if(responseData.count > 0 && responseData.count <= 32767){
            tlvs.append(try TLV(typeVal: TCMPTlvTag.tappyTagResponseData.rawValue, value: responseData))
            self.responseData = responseData
        }else if (responseData.count > 32767){
            throw TCMPCompositionError.parameterExceedsMaximumSize
        }
        
        if(customAid.count > 0 && customAid.count <= 16){
            tlvs.append(try TLV(typeVal: TCMPTlvTag.tappyTagCustomAid.rawValue, value: customAid))
            self.customAid = customAid
        }else if(customAid.count > 16){
            throw TCMPCompositionError.parameterExceedsMaximumSize
        }
        
        if(shouldSwitchToKeyboardEmulation){
            tlvs.append(try TLV(typeVal: TCMPTlvTag.tappyTagShouldSwitchToKeyboardMode.rawValue, value: []))
            shouldSwitchToKeyboardMode = true
        }
        
        rawTlvs = try writeTLVsToByteArray(tlvs: tlvs)
    }
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        var tlvs : [TLV]
        tlvs = try parseTlvByteArray(tlvByteArray: payload)
        rawTlvs = payload
        
        let timeoutValue : [UInt8] = fetchTlvValue(tagToFetch: TCMPTlvTag.pollingTimeout.rawValue, from: tlvs)
        if (timeoutValue.count == 1){
            timeout = timeoutValue[0]
        }
        
        responseData = fetchTlvValue(tagToFetch: TCMPTlvTag.tappyTagResponseData.rawValue, from: tlvs)
        customAid = fetchTlvValue(tagToFetch: TCMPTlvTag.tappyTagCustomAid.rawValue, from: tlvs)
        
        if (nil != fetchTlvIfPresent(tagToFetch: TCMPTlvTag.tappyTagShouldSwitchToKeyboardMode.rawValue, from: tlvs)){
            shouldSwitchToKeyboardMode = true
        }
    }
}
