//
//  ByteUtils.swift
//  SwiftTLV
//
//  Created by David Shalaby on 2021-06-07.
//
/*
 * Copyright (c) 2021. Papyrus Electronics, Inc d/b/a TapTrack.
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

@objc public class ByteUtils : NSObject {
    
    public static func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        withUnsafeBytes(of: value.bigEndian, Array.init)
    }

    public static func bytesToUInt(bytes: [UInt8]) throws -> UInt32{
        
        let data = Data(bytes: bytes)
        var value8 : UInt8
        var value16 : UInt16
        var value32 : UInt32
        if (bytes.count == 1){
            value8 = UInt8(bigEndian: data.withUnsafeBytes({$0.pointee}))
            return UInt32(value8)
        }else if (bytes.count == 2){
            value16 = UInt16(bigEndian: data.withUnsafeBytes({$0.pointee}))
            return UInt32(value16)
        }else if (bytes.count == 4){
            value32 = UInt32(bigEndian: data.withUnsafeBytes({$0.pointee}))
            return value32
        }else{
            throw TLVError.UnsupportedIntegerSize
        }
    }
}
