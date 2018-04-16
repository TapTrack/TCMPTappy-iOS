//
//  TagFoundResponse.swift
//  TapTrackReader
//
//  Created by David Shalaby on 2018-04-15.
//  Copyright © 2018 David Shalaby. All rights reserved.
//
/*
 * Copyright (c) 2018. Papyrus Electronics, Inc d/b/a TapTrack.
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

@objc public class TagFoundResponse : NSObject, TCMPMessage{
    
    @objc public private(set) var commandCode: UInt8{
        get{
            return TagFoundResponse.getCommandCode()
        }
        set{}
    }
    
    @objc public private(set) var payload: [UInt8]{
        get{
            
            return [tagType.getTagByteIndicator()] + tagCode
            
        }
        set{}
    }
    
    @objc public private(set) var commandFamily: [UInt8] = [0x00,0x01]
    
    @objc public private(set) var tagType : TagTypes = TagTypes.TAG_UNKNOWN
    
    @objc public private(set) var tagCode : [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    
    @objc public func parsePayload(payload: [UInt8]) throws {
        if (payload.count < 5){ //Some tags have 4 byte UIDs, so the minimum valid response size is 5 with the tag type indicator byte
            throw TCMPParsingError.payloadTooShort
        }else{
            tagType = TagTypes.init(tagCodeByteIndicator: payload[0])
            let numTagCodeBytes : UInt8 = (UInt8)(payload.count - 1)
            let tagCodeBytes = payload[1...Int(numTagCodeBytes)]
            tagCode = Array(tagCodeBytes)
        }
    }
    
    
    @objc static func getCommandCode() -> UInt8 {
        return 0x01
    }
}
