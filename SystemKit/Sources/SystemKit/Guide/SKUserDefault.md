```TEXT
/*
 * Copyright (c) 2022 ChangYeop-Yang. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
```

# SKUserDefault

`SKUserDefault`는 `@propertyWrapper` 사용하여 개발자가 보다 손쉽게 `UserDefaults` 사용할 수 있도록 개발되었습니다. 그러므로 [UserDefaults - Apple Developer Documentation](https://developer.apple.com/documentation/foundation/userdefaults)에서 사용할 수 있는 다양한 자료형을 처리할 수 있습니다.

# Example Source

```Swift
// Usage String UserDefaults
@SKUserDefaults(forKey: "SKUserDefault_TEST_STRING", defaultValue: "TEST")
private var defaultsString: Optional<String>

self.defaultsString = "SKUserDefault_PRINT"
printf(self.defaultsString)

// Usage Integer UserDefaults
@SKUserDefaults(forKey: "SKUserDefault_TEST_INTEGER", defaultValue: 3540)
private var defaultsInteger: Optional<Int>

self.defaultsInteger = 8557
printf(self.defaultsInteger)

// Usage Double UserDefaults
@SKUserDefaults(forKey: "SKUserDefault_TEST_DOUBLE", defaultValue: 3.14)
private var defaultsDouble: Optional<Double>

self.defaultsInteger = 41.3
printf(self.defaultsDouble)
```
