//
//  NDEFFoundResponse.swift
//  TCMP
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


public class NDEFFoundResponse : TCMPMessage{
    public private(set) var commandCode: UInt8{
        get{
            return NDEFFoundResponse.getCommandCode()
        }
        set{}
    }
    public private(set) var payload: [UInt8]{
        get{

           return [tagType.getTagByteIndicator(),UInt8(tagCode.count)] + tagCode + ndefMessage

        }
        set{}
    }
    public private(set) var commandFamily: [UInt8] = [0x00,0x01]
    
    /*
     Right now it seems I can't find an appropriate NDEF library as a cocoapod or other open source lib in Swift that does
     what I need without the CoreNFC dependency.  Since the target is lower versions of iOS (those that don't support CoreNFC)
     I will make the ndefMessage field a byte array without validation for now TODO: Write an NDEF library in Swift without CoreNFC dependency
    */

    
    public private(set) var tagCode : [UInt8] = [0x00,0x00,0x00,0x00,0x00,0x00,0x00]
    public private(set) var tagType : TagTypes = TagTypes.TAG_UNKNOWN
    public private(set) var ndefMessage : [UInt8] = [0xD0] //empty NDEF record header/TNF
    
    public init(){}
    
    public init(tagCode : [UInt8], tagType : UInt8, ndefMessage : [UInt8]){
        self.tagCode = tagCode
        self.tagType = TagTypes.init(tagCodeByteIndicator: tagType)
        self.ndefMessage = ndefMessage
    }
    
    public init(tagCode : [UInt8], tagType : TagTypes, ndefMessage : [UInt8]){
        self.tagCode = tagCode
        self.tagType = tagType
        self.ndefMessage = ndefMessage
    }
    
    public func parsePayload(payload: [UInt8]) throws {
        if (payload.count < 2){
            throw TCMPParsingError.payloadTooShort
        }else if(UInt(payload[1]) > payload.count+2){
            throw TCMPParsingError.notAllTagCodeBytesPresent
        }else{
            tagType = TagTypes.init(tagCodeByteIndicator: payload[0])
            let numTagCodeBytes : UInt8 = payload[1]
            let tagCodeBytes = payload[2...2+Int(numTagCodeBytes)]
            tagCode = Array(tagCodeBytes)
            let ndefMessageBytes = payload[2+Int(numTagCodeBytes)...payload.count-1]
            ndefMessage = Array(ndefMessageBytes)
        }
    }
    
    static func getCommandCode() -> UInt8 {
        return 0x02
    }
    
}

