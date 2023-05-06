; 定義一個數據段，用來存儲數據
section .data
message db 'Hello World!', 10 ; 定義一個字符串變量，10是換行符
msglen equ $-message ; 定義一個長度變量，用來表示字符串的長度

; 定義一個代碼段，用來存儲指令
section .text
global _start ; 告訴編譯器從_start標籤開始執行

_start:
mov eax, 4 ; 把4移動到eax寄存器中，表示系統調用write
mov ebx, 1 ; 把1移動到ebx寄存器中，表示標準輸出
mov ecx, message ; 把message的地址移動到ecx寄存器中，表示要輸出的內容
mov edx, msglen ; 把msglen的值移動到edx寄存器中，表示要輸出的長度
int 0x80 ; 執行系統調用

mov eax, 1 ; 把1移動到eax寄存器中，表示系統調用exit
mov ebx, 0 ; 把0移動到ebx寄存器中，表示退出代碼
int 0x80 ; 執行系統調用