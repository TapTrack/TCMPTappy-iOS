//
//  StopCommand.swift
//  TCMP
//
//  Created by Frank Hackenburg on 2018-04-09.
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
public class StopCommand : NSObject, TCMPMessage {
    @objc
    public private(set) var commandCode: UInt8{
        get{
            return StopCommand.getCommandCode()
        }
        set{}
    }
    @objc
    public var payload: [UInt8]{
        get{
            return []
        }
    }
    
    
    @objc public private(set) var commandFamily: [UInt8] = [0x00,0x01]
    @objc public override init(){}
    
    @objc
    public func parsePayload(payload: [UInt8]) throws {}
    @objc
    public static func getCommandCode() -> UInt8 {
        return 0x00
    }
}



