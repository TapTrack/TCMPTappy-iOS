//
//  BasicNfcApplicationErrorMessage.swift
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


public class BasicNfcApplicationErrorMessage : TCMPMessage, TCMPApplicationErrorMessage {
   
    public private(set) var commandCode: UInt8 {
        get{
            return BasicNfcApplicationErrorMessage.getCommandCode()
        }
        set{}
    }
   public private(set) var payload: [UInt8] {
        get {
            return [appErrorCode,internalErrorCode,readerStatusCode] + errorDescription.utf8
        }
        set{}
    }
    
   public private(set) var commandFamily: [UInt8] = [0x00,0x01]
    
   public private(set) var appErrorCode: UInt8 = 0x00
   public private(set) var internalErrorCode: UInt8 = 0x00
   public private(set) var readerStatusCode: UInt8 = 0x00
   public private(set) var errorDescription: String = ""
    
    public init(){}
    
    public func parsePayload(payload: [UInt8]) throws {
        appErrorCode = payload[0]
        internalErrorCode = payload[1]
        readerStatusCode = payload[2]
        let errorDescriptionBytes = Data(payload[3...payload.count-1])
        errorDescription = String(data: errorDescriptionBytes, encoding: .utf8)!
    }
    
    static func getCommandCode() -> UInt8 {
        return 0x7F
    }

}
