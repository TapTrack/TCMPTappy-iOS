//
//  StreamNDEFCommand.swift
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

public class StreamNDEFCommand : TCMPMessage{
    var commandCode: UInt8{
        get{
            return StreamNDEFCommand.getCommandCode()
        }
    }
    var payload: [UInt8]{
        get{
            if(pollingMode == PollingMode.pollForType1){
                return [timeout,0x01]
            }else if(pollingMode == PollingMode.pollForGeneral){
                return [timeout,0x02]
            }else{
                return []
            }
        }
    }
    let commandFamily: [UInt8] = [0x00,0x01]
    
    var timeout : UInt8 = 0x00
    var pollingMode : PollingMode = PollingMode.pollForGeneral
    
    func parsePayload(payload: [UInt8]) throws {
        if(payload.count >= 2){
            timeout = payload[0]
            switch (payload[1]){
            case 0x01:
                pollingMode = PollingMode.pollForType1
            case 0x02:
                pollingMode = PollingMode.pollForGeneral
            default:
                throw TCMPParsingError.invalidPollingMode
            }
        }else{
            throw TCMPParsingError.payloadTooShort
        }
    }
    
    static func getCommandCode() -> UInt8 {
        return 0x03
    }
}
