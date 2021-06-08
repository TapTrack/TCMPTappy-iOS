//
//  TLV.swift
//  SwiftTLV
//
//  Created by David Shalaby on 2021-06-03.
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

public struct TLV : Equatable{
    public private(set) var tag: UInt32
    public private(set) var value : [UInt8]
    
    public init(){
        tag = 0
        value = []
    }
    
    public init(typeVal: UInt32, value: [UInt8]) throws{
        if(typeVal > 65279){
            throw TLVError.InvalidTypeValue
        }
        if (value.count > 65279){
            throw TLVError.InvalidValueLength
        }
        self.tag = typeVal
        self.value = value
    }
    
    public func toByteArray() throws -> [UInt8] {
        if(tag > 65279){
            throw TLVError.InvalidTypeValue
        }
        if (value.count > 65279){
            throw TLVError.InvalidValueLength
        }
        var tlvAsByteArray : [UInt8] = []
        if(tag > 254){
            tlvAsByteArray.append(0xFF)
            tlvAsByteArray.append(contentsOf: ByteUtils.byteArray(from: Int16(tag)))
        }else{
            tlvAsByteArray.append(contentsOf: ByteUtils.byteArray(from: Int8(tag)))
        }
        
        if(value.count > 254){
            tlvAsByteArray.append(0xFF)
            tlvAsByteArray.append(contentsOf: ByteUtils.byteArray(from: Int16(value.count)))
        }else{
            tlvAsByteArray.append(contentsOf: ByteUtils.byteArray(from: Int8(value.count)))
        }
        
        tlvAsByteArray.append(contentsOf: value)
        
        return tlvAsByteArray
    }
}

public func writeTLVsToByteArray(tlvs: [TLV]) throws -> [UInt8]{
    var tlvsAsByteArray : [UInt8] = []
    
    for tlv in tlvs {
        do{
            try tlvsAsByteArray.append(contentsOf: tlv.toByteArray())
        }catch TLVError.InvalidTypeValue{
            throw TLVError.InvalidValueLength
        }catch TLVError.InvalidValueLength{
            throw TLVError.InvalidValueLength
        }catch{
            throw TLVError.UnknownOrOther
        }
    }
    
    return tlvsAsByteArray
}

public func parseTlvByteArray(tlvByteArray: [UInt8]) throws -> [TLV]{
    if (tlvByteArray.count < 2){
        throw TLVError.ArrayTooShort
    }
    
    var currentIndex : UInt32 = 0
    var tlvs : [TLV] = []
    var tag : UInt32
    var length : UInt32
    var value : [UInt8] = []
    var isTwoByteTag : Bool
    var isTwoByteLength : Bool
    
    do{
        while(currentIndex + 2 <= tlvByteArray.count){
            isTwoByteTag = false
            isTwoByteLength = false
            value = []
            if(tlvByteArray[Int(currentIndex)] == 0xFF){ //two byte tag
                if(currentIndex+2 < tlvByteArray.count){
                    isTwoByteTag = true
                    tag = try ByteUtils.bytesToUInt(bytes: [tlvByteArray[Int(currentIndex+1)],tlvByteArray[Int(currentIndex+2)]])
                }else{
                    throw TLVError.ArrayTooShort
                }
            }else{ //one byte tag
                tag = UInt32(tlvByteArray[Int(currentIndex)])
            }
            
            if (isTwoByteTag){
                if(currentIndex + 3 < tlvByteArray.count){
                    if(tlvByteArray[Int(currentIndex+3)] == 0xFF){ //two byte length with two byte tag
                        isTwoByteLength = true
                        if(currentIndex + 5 < tlvByteArray.count){
                            length = try ByteUtils.bytesToUInt(bytes: [tlvByteArray[Int(currentIndex+4)],tlvByteArray[Int(currentIndex+5)]])
                        }else{
                            throw TLVError.ArrayTooShort
                        }
                    }else{ //one byte length with two byte tag
                        if(currentIndex + 3 < tlvByteArray.count){
                            length = try ByteUtils.bytesToUInt(bytes: [tlvByteArray[Int(currentIndex+3)]])
                        }else{
                            throw TLVError.ArrayTooShort
                        }
                    }
                }else{
                    throw TLVError.ArrayTooShort
                }
           
            }else{
                if(tlvByteArray[Int(currentIndex+1)] == 0xFF){ //two byte length with one byte tag
                    isTwoByteLength = true
                    if(currentIndex + 3 < tlvByteArray.count){
                        length = try ByteUtils.bytesToUInt(bytes: [tlvByteArray[Int(currentIndex+2)],tlvByteArray[Int(currentIndex+3)]])
                    }else{
                        throw TLVError.ArrayTooShort
                    }
                }else{ //one byte length with one byte tag
                    length = try ByteUtils.bytesToUInt(bytes: [tlvByteArray[Int(currentIndex+1)]])
                }
            }
                
            if(tlvByteArray.count < currentIndex + length + 2){
                throw TLVError.ArrayTooShort
            }
                         
            var valueStart : UInt32
            
            if (isTwoByteTag && isTwoByteLength){
                valueStart = currentIndex + 6
            }else if (isTwoByteTag && !isTwoByteLength){
                valueStart = currentIndex + 4
            }else if (!isTwoByteTag && isTwoByteLength){
                valueStart = currentIndex + 4
            }else if(!isTwoByteTag && !isTwoByteLength){
                valueStart = currentIndex + 2
            }else{
                throw TLVError.UnknownOrOther
            }
            
            if(valueStart + length - 1 < tlvByteArray.count && length != 0){
                value.append(contentsOf: tlvByteArray[Int(valueStart)...Int(valueStart+length-1)])
            }else if (length != 0){
                throw TLVError.ArrayTooShort
            }
                        
            do{
                try tlvs.append(TLV(typeVal: tag, value: value))
            }catch TLVError.InvalidTypeValue{
                throw TLVError.InvalidValueLength
            }catch TLVError.InvalidValueLength{
                throw TLVError.InvalidValueLength
            }catch{
                throw TLVError.UnknownOrOther
            }
            
            currentIndex = currentIndex + (isTwoByteTag ? 3 : 1) + (isTwoByteLength ? 3 : 1) + length
        }
    }catch TLVError.ArrayTooShort{
        throw TLVError.ArrayTooShort
    }catch TLVError.InvalidTypeValue{
        throw TLVError.InvalidTypeValue
    }catch TLVError.InvalidValueLength{
        throw TLVError.InvalidValueLength
    }catch TLVError.UnsupportedIntegerSize{
        throw TLVError.UnsupportedIntegerSize
    }catch{
        throw TLVError.UnknownOrOther
    }
    
    return tlvs
}

public func fetchTlv(tagToFetch: UInt32, from: [TLV]) throws -> TLV{
    for tlv in from{
        if (tlv.tag == tagToFetch){
            return tlv
        }
    }
    throw TLVError.TlvNotFound
}

public func fetchTlvIfPresent(tagToFetch: UInt32, from: [TLV]) -> TLV?{
    for tlv in from{
        if (tlv.tag == tagToFetch){
            return tlv
        }
    }
    return nil
}

public func fetchTlvValue(tagToFetch : UInt32, from :[TLV]) -> [UInt8]{
    for tlv in from{
        if (tlv.tag == tagToFetch){
            return tlv.value
        }
    }
    return []
}

public enum TLVError: Error{
    case InvalidTypeValue
    case InvalidValueLength
    case ArrayTooShort
    case UnsupportedIntegerSize
    case TlvNotFound
    case UnknownOrOther
}
