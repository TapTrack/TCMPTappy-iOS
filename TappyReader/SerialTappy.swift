//
//  SerialTappy.swift
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
public class SerialTappy : NSObject, Tappy {
    
    @objc var communicator : TappySerialCommunicator
    @objc var receiveBuffer : [UInt8] = []
    @objc var statusListener : (TappyStatus) -> () = {_ in func emptyStatusListener(status: TappyStatus) -> (){}}
    @objc var responseListener : (TCMPMessage, String) -> () = {_,_ in func emptyResponseListener(message: TCMPMessage, data: String) -> (){}}
    @objc var unparsableListener : ([UInt8]) -> () = {_ in func emptyUnparsablePacketListener(packet : [UInt8]) -> (){}}
    
    
    @objc public init(communicator : TappySerialCommunicator){
        responseListener = {_,_ in func emptyResponseListener(message: TCMPMessage, data: String) -> (){}}
        statusListener = {_ in func emptyStatusListener(status: TappyStatus) -> (){}}
        unparsableListener = {_ in func emptyUnparsablePacketListener(packet : [UInt8]) -> (){}}
        self.communicator = communicator
        super.init()
        communicator.setDataListener(receivedBytes: receiveBytes)
        communicator.setStatusListener(statusReceived: notifyListenerOfStatus)
    }
    
    @objc public func receiveBytes(data : [UInt8]){
        NSLog("Receiving Bytes");
        var commands : [[UInt8]] = [[]]
        receiveBuffer.append(contentsOf: data)
        if(TCMPUtils.containsHdlcEndpoint(packet: data)){
            let currentBuffer : [UInt8] = receiveBuffer
            let parseResult : TCMPUtils.HDLCParseResult = TCMPUtils.HDLCByteArrayParser(bytes: currentBuffer)
            commands = parseResult.getPackets()
            receiveBuffer = parseResult.getRemainder()
        }
        
        if (commands.count == 0){
            return
        }
        
        for hdlcPacket in commands{
            do{
                let decodedPacket : [UInt8] = try TCMPUtils.hdlcDecodePacket(frame: hdlcPacket)
                if(decodedPacket.count != 0){
                    do{
                        let message : RawTCMPMesssage = try RawTCMPMesssage(message: decodedPacket)
                        // need to resolve the message first
                        let basicNFCResolver: BasicNFCCommandResolver = BasicNFCCommandResolver()
                        let resolvedResponse = try basicNFCResolver.resolveResponse(message: message)
                        // var jsonObject: [String: Any] = [:]
                        if (resolvedResponse is NDEFFoundResponse) {
                            NSLog("It's an NDEFFoundResponse")
                            // now get the payload
                            let tagReadResponse : NDEFFoundResponse = NDEFFoundResponse()
                            try tagReadResponse.parsePayload(payload: resolvedResponse.payload) //no need to handle exception here since the resolver would not have returned otherwise
                            let ndefText = basicNFCResolver.getNdefTextPayload(ndefResponse: tagReadResponse)
                            NSLog(String(format: "Text: %@", arguments: [ndefText!]))
                            // cast it
                            let ndefResponse = resolvedResponse as! NDEFFoundResponse
                            // now create a JSON object here
                            NSLog("Begin JSON attempt")
                            let jsonObject : [String: Any] = [
                                "ndefText": ndefText as! String,
                                "payload": ndefResponse.payload,
                                "tagCode": ndefResponse.tagCode,
                                "commandCode": ndefResponse.commandCode,
                                "commandFamily": ndefResponse.commandFamily
                            ]
                            NSLog(String(format: "Description: %@", arguments: [jsonObject.description]))
                            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
                            NSLog(String(format: "Passing back JSON string: %@", arguments: [jsonString]))
                            responseListener(message, jsonString)

                        } else {
                            responseListener(message, "{}")
                        }
                        
                    }catch{
                        unparsableListener(hdlcPacket)
                    }
                }else{
                    unparsableListener(hdlcPacket)
                }
            }catch{
                unparsableListener(hdlcPacket)
            }
        }
    }
    
    @objc public func setResponseListener(listener: @escaping (TCMPMessage, String) -> ()) {
        responseListener = listener
    }
    
    @objc public func removeResponseListener() {
        responseListener = {_,_ in func emptyResponseListener(message: TCMPMessage, data: String) -> (){}}
    }
    
    @objc public func setStatusListener(listner: @escaping (TappyStatus) -> ()) {
        statusListener = listner
    }
    
    @objc public func removeStatusListener() {
        statusListener = {_ in func emptyStatusListener(status: TappyStatus) -> (){}}
    }
    
    @objc public func setUnparsablePacketListener(listener: @escaping ([UInt8]) -> ()) {
        unparsableListener = listener
    }
    
    @objc public func removeUnparsablePacketListener() {
        unparsableListener = {_ in func emptyUnparsablePacketListener(packet : [UInt8]) -> (){}}
    }
    
    @objc public func removeAllListeners() {
        removeResponseListener()
        removeUnparsablePacketListener()
        removeUnparsablePacketListener()
    }
    
    @objc private func notifyListenerOfStatus(status : TappyStatus){
        statusListener(status)
    }
    
    @objc public func connect(){
        communicator.connect()
        
    }
    
    @objc public func sendMessage(message: TCMPMessage) {
        communicator.sendBytes(data: TCMPUtils.hdlcEncodePacket(packet: message.toByteArray()))
    }
    
    @objc public func disconnect() {
        communicator.disconnect()
    }
    
    @objc public func close() {
        communicator.close()
    }
    
    @objc public func getDeviceDescription() -> String {
        return communicator.getDeviceDescription();
    }
    
    @objc public func getLatestStatus() -> TappyStatus {
        return communicator.state
    }
    
    @objc public func getCommunicator() -> TappySerialCommunicator{
        return communicator
    }
    
}


