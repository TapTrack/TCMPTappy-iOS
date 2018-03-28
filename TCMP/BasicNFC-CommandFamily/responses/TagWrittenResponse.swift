//
//  TagWrittenResponse.swift
//  TappySDKExampleWithSDKSource
//
//  Created by David Shalaby on 2018-03-08.
//  Copyright © 2018 Papyrus Electronics Inc d/b/a TapTrack. All rights reserved.
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

public class TagWrittenResponse : TCMPMessage{
    public private(set) var commandCode: UInt8 {
        get{
            return TagWrittenResponse.getCommandCode()
        }
        set{}
        
    }
    
    public private(set) var payload: [UInt8] {
        get{
            return [tagType.getTagByteIndicator()] + tagCode
        }
        set{}
    }

    public private(set) var commandFamily: [UInt8] = [0x00,0x01]
    public private(set) var  tagCode : [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    @objc public private(set) var  tagType : TagTypes = TagTypes.TAG_UNKNOWN
    
    public init(){}
    
    public init(tagCode : [UInt8], tagType: TagTypes){
        self.tagCode = tagCode
        self.tagType = tagType
    }

    public func parsePayload(payload: [UInt8]) throws {
        if (payload.count > 1){
            tagType = TagTypes(tagCodeByteIndicator: payload[0])
            tagCode = Array(payload[1...payload.count-1])
        }
    }
    public static func getCommandCode() -> UInt8{
        return 0x05
    }


}

