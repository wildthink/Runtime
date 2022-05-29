// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public protocol ModelConversionProtocol {
    var conversions: [String : PropertyConversionProtocol] { get set }
}

public class ModelConversion<S, D>: ModelConversionProtocol {
    
    public var conversions: [String : PropertyConversionProtocol]
    
    public init(conversions: [String : PropertyConversionProtocol]) {
        self.conversions = conversions
    }
    
    @discardableResult
    public func `for`<T>(property: String, use getter: @escaping (S) throws -> T) -> ModelConversion<S, D>{
        conversions[property] = CustomPropertyConversionClosure<S, D, T>(property: property, getter: getter)
        return self
    }
    
    @discardableResult
    public func `for`<T>(property: String, use path: KeyPath<S, T>) -> ModelConversion<S, D>{
        conversions[property] = CustomPropertyConversionKeyPath<S, D, T>(property: property, path: path)
        return self
    }
    
    @discardableResult
    public func ignore(property: String) -> ModelConversion<S, D>{
        conversions.removeValue(forKey: property)
        return self
    }
    
    func getKey() -> String {
        return "\(S.self)\(D.self)"
    }
}
