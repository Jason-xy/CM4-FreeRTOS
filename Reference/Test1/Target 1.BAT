SET PATH=D:\program\Keil_v5\ARM\ARMCC\Bin;D:\Program\Xftp 6\;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files\Intel\WiFi\bin\;C:\Program Files\Common Files\Intel\WirelessCommon\;D:\Program\Microsoft VS Code\bin;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\Java\jdk-13.0.2\bin\;C:\Program Files\nodejs\;C:\Program Files\dotnet\;D:\program\TDM-GCC-64\bin;C:\Users\VergilYZX\AppData\Local\Programs\Python\Python39\Scripts\;C:\Users\VergilYZX\AppData\Local\Programs\Python\Python39\;C:\Users\VergilYZX\AppData\Local\Microsoft\WindowsApps;;%CLion%;D:\Program\Bandizip\;C:\Users\VergilYZX\AppData\Roaming\npm;C:\Users\VergilYZX\AppData\Local\Microsoft\WindowsApps
SET CPU_TYPE=STM32F103C8
SET CPU_VENDOR=STMicroelectronics
SET UV2_TARGET=Target 1
SET CPU_CLOCK=0x044AA200
"D:\program\Keil_v5\ARM\ARMCC\Bin\ArmAsm" --Via ".\objects\led_ir._ia"
"D:\program\Keil_v5\ARM\ARMCC\Bin\ArmLink" --Via ".\Objects\ASM_INT_LED.lnp"
"D:\program\Keil_v5\ARM\ARMCC\Bin\fromelf.exe" ".\Objects\ASM_INT_LED.axf" --i32combined --output ".\Objects\ASM_INT_LED.hex"
fromelf  --bin  --output=ASM_INT_LED.bin ./Objects/ASM_INT_LED.axf
fromelf  --text  -a -c  --output=ASM_INT_LED.dis ./Objects/ASM_INT_LED.axf
