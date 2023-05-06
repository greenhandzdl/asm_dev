# Test and release ASM action
這是一個GitHub Actions動作，它可以自動化測試和發布你的組合語言文件。

## 使用方法
* 要使用這個動作，你需要在你的倉庫中創建一個名為asm_name的secret，並把它的值設置為你的asm文件的名稱，比如hello.asm。你可以在倉庫的Settings -> Secrets -> Actions secrets中創建和管理secrets。
* 然後，你需要在你的倉庫中創建一個.github/workflows目錄，然後在裡面創建一個yaml文件，比如test-and-release-asm.yml。