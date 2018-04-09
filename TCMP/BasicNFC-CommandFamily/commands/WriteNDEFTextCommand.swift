//
//  WriteNdefTextCommand.swift
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
@objc
public class WriteNDEFTextCommand : NSObject, TCMPMessage
{
    
    @objc public private(set) var commandCode : UInt8{
        get{
            return WriteNDEFTextCommand.getCommandCode()
        }
        set{}
    }
    
    @objc public private(set) var commandFamily : [UInt8] = [0x00,0x01]
    @objc public private(set) var payload: [UInt8]{
        get {
            var lockFlagByte: UInt8
            if(lockFlag == LockingMode.LOCK_TAG){
                lockFlagByte = 0x01
            }else{
                lockFlagByte = 0x00
            }
            
            return [timeout,lockFlagByte] + text
        }
        set{}
    }
    
    @objc public private(set) var lockFlag : LockingMode = LockingMode.DONT_LOCK_TAG
    @objc public private(set) var timeout : UInt8 = 0
    @objc public private(set) var text : [UInt8] = []
    
    @objc public override init(){}
    
    @objc public init(timeout: UInt8, lockTag: LockingMode, text: String){
        self.timeout = timeout
        lockFlag = lockTag
        self.text = Array(text.utf8)
    }
    
    @objc public func parsePayload(payload : [UInt8]) throws {
        if(payload.count >= 2){
            timeout = payload[0]
            
            if(payload[1] == 0x00){
                lockFlag = LockingMode.DONT_LOCK_TAG
            }else{
                lockFlag = LockingMode.LOCK_TAG
            }
            
            if(payload.count > 2){
                text = Array(payload[2...payload.count-1])
            }else{
                text = []
            }
            
        }else{
            throw TCMPParsingError.payloadTooShort
        }
    }
    
    @objc static func getCommandCode() -> UInt8{
        return 0x06
    }
    
    
}
