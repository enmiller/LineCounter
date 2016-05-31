#!/usr/bin/swift

/**
 To run LineCounter.swift:
 xcrun swift LineCounter.swift <folder_path> <file_extension>
 
 - Parameter folder_path: The folder to recursively check for files.
 - Parameter file_extension: The extension type of the files to count lines of code in.
 */

import Foundation

let fileManager = NSFileManager.defaultManager()
let folderPath: String = Process.arguments[1]
let fileExtension: String = Process.arguments[2]

if let folderEnumerator: NSDirectoryEnumerator = fileManager.enumeratorAtPath(folderPath) {
    
    var totalFolderLineCount: Int = 0
    for file in folderEnumerator.allObjects {
        if let filePath = file as? String {
            guard filePath.containsString("Carthage/") == false else {
                continue
            }
            
            guard filePath.hasSuffix(fileExtension) else {
                continue
            }
            
            do {
                let fullFilePath = folderPath.stringByAppendingString("/\(filePath)")
                let fileContents = try String(contentsOfFile: fullFilePath, encoding: NSUTF8StringEncoding)
                if let fileContentsArray: Array<String> = fileContents.componentsSeparatedByString("\n") {
                    
                    var trimmedLineCount: Int = 0
                    for line in fileContentsArray {
                        let trimmedLine = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        guard !trimmedLine.isEmpty else {
                            continue
                        }
                        trimmedLineCount = trimmedLineCount + 1
                    }
                    totalFolderLineCount = totalFolderLineCount + trimmedLineCount
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    print("Total LOC: \(totalFolderLineCount)")
}
