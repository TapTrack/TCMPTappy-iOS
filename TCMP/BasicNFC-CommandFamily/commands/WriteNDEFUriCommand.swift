//
//  WriteNDEFUriCommand.swift
//  TappyBLE
//
//  Created by Ga-Chun Lin on 2019-03-19.
//  Copyright © 2019 TapTrack. All rights reserved.
//

import Foundation

@objc
public class WriteNDEFUriCommand : NSObject, TCMPMessage
{
    
    enum WriteNDEFUriError: Error {
        case payloadTooShort
    }
    
    @objc public private(set) var commandCode : UInt8{
        get{
            return WriteNDEFUriCommand.getCommandCode()
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
            
            return [timeout,lockFlagByte,uriCode] + uri
        }
        set{}
    }
    
    @objc public private(set) var lockFlag : LockingMode = LockingMode.DONT_LOCK_TAG
    @objc public private(set) var timeout : UInt8 = 0
    @objc public private(set) var uri : [UInt8] = []
    @objc public private(set) var uriCode : UInt8 = 0x00
    
    @objc public override init(){}
    
    @objc public init(timeout: UInt8, lockTag: LockingMode, uri: String){
        self.timeout = timeout
        self.lockFlag = lockTag
        self.uri = Array(uri.utf8)
    }
    
    @objc public func parsePayload(payload : [UInt8]) throws {
        if(payload.count > 2){
            timeout = payload[0]
            
            if(payload[1] == 0x00){
                lockFlag = LockingMode.DONT_LOCK_TAG
            }else{
                lockFlag = LockingMode.LOCK_TAG
            }
            
            uriCode = payload[2]
            
            if(payload.count > 3){
                uri = Array(payload[3...payload.count-1])
            }else{
                uri = []
            }
        
        }else{
            throw WriteNDEFUriError.payloadTooShort
        }
    }
    
    @objc static func getCommandCode() -> UInt8{
        return 0x05
    }
    
    
}
