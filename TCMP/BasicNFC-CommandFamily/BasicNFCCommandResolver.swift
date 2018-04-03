//
//  BasicNFCCommandResolver.swift
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

@objc public class BasicNFCCommandResolver : NSObject, MessageResolver{
    @objc public let FAMILY_ID : [UInt8] = [0x00,0x01]
    
    @objc public override init(){}
    
    private func assertFamilyMatches(message: TCMPMessage) throws {
        if(message.commandFamily.count != 2 || message.commandFamily[0] != FAMILY_ID[0] || message.commandFamily[1] != FAMILY_ID[1]){
            throw TCMPParsingError.resolverError(errorDescription: "Specified message is for a different command family")
        }
    }
   @objc 
   public func resolveCommand(message: TCMPMessage) throws -> TCMPMessage {
        try assertFamilyMatches(message: message)
        var parsedMessage : TCMPMessage
        
        switch message.commandCode {
            case WriteNDEFTextCommand.getCommandCode():
                parsedMessage = WriteNDEFTextCommand()
            case ScanNDEFCommand.getCommandCode():
                parsedMessage = ScanNDEFCommand()
            case StreamNDEFCommand.getCommandCode():
                parsedMessage = StreamNDEFCommand()
            default:
                throw TCMPParsingError.resolverError(errorDescription: "Unrecognized Command Code")
        }
        
        do{
            try parsedMessage.parsePayload(payload: message.payload)
        }catch{
            throw TCMPParsingError.resolverError(errorDescription: "Message failed to parse")
        }
        
        return parsedMessage
        
    }
    @objc
    public func resolveResponse(message: TCMPMessage) throws -> TCMPMessage {
        try assertFamilyMatches(message: message)
        var parsedMessage : TCMPMessage
        
        switch message.commandCode {
        case BasicNfcApplicationErrorMessage.getCommandCode():
            parsedMessage = BasicNfcApplicationErrorMessage()
        case TagWrittenResponse.getCommandCode():
            parsedMessage = TagWrittenResponse()
        case NDEFFoundResponse.getCommandCode():
            parsedMessage = NDEFFoundResponse()
        default:
            throw TCMPParsingError.resolverError(errorDescription: "Unrecognized Response Code")
        }
        
        try parsedMessage.parsePayload(payload: message.payload)
        return parsedMessage
    }
}
