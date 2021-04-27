                PRESERVE8							;指示编译器8字节对齐
                THUMB								;指示编译器以后的指令为THUMB指令								

Stack_Size      EQU     0x00000400
RCC_APB2ENR		EQU		0x40021000 + 0x18
GPIOC_CRH		EQU		0x40011000 + 0x04
GPIOC_ODR		EQU		0x40011000 + 0x0C
GPIOB_CRH		EQU		0x40010C00 + 0x04
GPIOB_ODR		EQU		0x40010C00 + 0x0C
GPIOA_CRL		EQU		0x40010800 + 0x00
AFIO_EXTICR1    EQU     0x40010000 + 0x08
SCB_AIRCR		EQU		0xE000ED0C
NVIC_ISER0      EQU     0xE000E100
NVIC_IP6		EQU		0xE000E406
EXTI_IMR		EQU		0x40010400 + 0x00
EXTI_FTSR		EQU		0x40010400 + 0x0C
EXTI_PR			EQU		0x40010400 + 0x14
EXC_RETURN		EQU		0xFFFFFFF9
	
                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp
;				AREA    InRoot$$Sections, CODE, READONLY
					
; Vector Table Mapped to Address 0 at Reset
				AREA    RESET, CODE, READONLY		;定义只读数据段，标记为RESET，其实放在CODE区，位于0地址
				EXPORT  __Vectors					;在程序中声明一个全局的标号__Vectors，该标号可在其他的文件中引用
					
__Vectors       DCD     __initial_sp        ;当前地址写入一个字(32bit)数据，值为0x00000000，实际是应该填入栈顶地址 
                DCD     Reset_Handler       ;当前地址写入一个字(32bit)数据，值为Reset_Handler的值，即程序入口地址
                DCD     0                	; NMI Handler
                DCD     0          			; Hard Fault Handler
                DCD     0          			; MPU Fault Handler
                DCD     0           		; Bus Fault Handler
                DCD     0         			; Usage Fault Handler
                DCD     0                   ; Reserved
                DCD     0                   ; Reserved
                DCD     0                   ; Reserved
                DCD     0                   ; Reserved
                DCD     0                	; SVCall Handler
                DCD     0           		; Debug Monitor Handler
                DCD     0                   ; Reserved
                DCD     0            		; PendSV Handler
                DCD     0            		; SysTick Handler
                DCD     0           		; Window Watchdog
                DCD     0             		; PVD through EXTI Line detect
                DCD     0          			; Tamper
                DCD     0             		; RTC
                DCD     0          			; Flash
                DCD     0             		; RCC
                DCD     EXTI0_IRQHandler    ; EXTI Line 0
				DCD		EXTI1_IRQHandler	; EXTI Line 1 测试向量表顺序代码
					
				AREA    |.text|, CODE, READONLY		;定义代码段，标记为.text
				ENTRY
				
Reset_Handler   PROC								;过程的开始 
				EXPORT  Reset_Handler	[WEAK]		;[WEAK] 弱定义，意思是如果在别处也定义该标号(函数)，在链接时用别处的地址。
				;LED PB12 KEY PA0
				
				CPSID I ;关中断
				
				; 1、开RCC的时钟
				LDR R0, =RCC_APB2ENR;定位RCC_APB2ENR
				LDR R1, [R0]
				ORR R1, R1, #0x15	;GPIOC、GPIOB、GPIOA、空、GPIOAFIO	10101 = D
				STR R1, [R0]
				
				; 2、把GPIOC13设置为推挽输出50Mhz [23:20]:0011  复位位 0100
				LDR R0, =GPIOC_CRH
				LDR R1, [R0]
				EOR R1, R1, R1;清空
				ORR R1, R1,#(3<<4*5)
				STR R1, [R0]
				
				; 3、把GPIOA0设置为下拉输入 [19:16]:1000  复位位 0100
				LDR R0, =GPIOA_CRL
				LDR R1, [R0]
				EOR R1, R1, R1;清空
				ORR R1, R1,#(8<<4*0)
				STR R1, [R0]				
				
				; 4、初始化NVIC分组SCB->AIRCR [10:8]:000  复位位 000
				LDR R0, =SCB_AIRCR
				LDR R1, [R0]
				AND R1, R1,#0xFFFFF8FF
				STR R1, [R0]
				
				; 5、初始化NVIC使能寄存器NVIC->ISER[0] [6]:1  复位位 全0
				LDR R0, =NVIC_ISER0
				LDR R1, [R0]
				ORR R1, R1,#(1<<6)
				STR R1, [R0]
				
				; 7、初始化NVIC优先级寄存器NVIC->IP[6] [6]:1  复位位 全0
				LDR R0, =NVIC_IP6
				LDR R1, [R0]
				EOR R1, R1, R1;全0，直接最高优先级
				STR R1, [R0]
				
				; 8、配置AFIO_EXTICR1，选择PA0为输入引脚 [3:0]:0000  复位位 0000
				LDR R0, =AFIO_EXTICR1
				LDR R1, [R0]
				EOR R1, R1, R1;清空
				STR R1, [R0]
				
				; 9、配置EXTI_FTSR，允许0线下降沿触发 [0]:1  复位位 0000
				LDR R0, =EXTI_FTSR
				LDR R1, [R0]
				ORR R1, R1, #1
				STR R1, [R0]
				
				; 10、配置EXTI_IMR，开放0线中断请求 [0]:1  复位位 0000
				LDR R0, =EXTI_IMR
				LDR R1, [R0]
				ORR R1, R1, #1
				STR R1, [R0]
				
				CPSIE I ;开中断
Loop				
				B Loop
                ENDP
					;过程的结束

delay
				SUBS R0, R0, #1
				BNE delay
				BX LR



EXTI0_IRQHandler\
				PROC
				EXPORT  EXTI0_IRQHandler             [WEAK]
				LDR	R0 ,=EXTI_PR
				LDR R1, [R0]
;				PUSH {R0}
;				LDR R0, =10000
;				BL delay
;				POP {R0}
				LDR R2, =GPIOC_ODR
				LDR R3, [R2]
				AND R1, R1, #1	;只保留最后一位
				CMP	R1, #1
				BNE	NO			;相减等于0，则表示最后一位是1，则产生中断，如果不相等，则没有中断产生，就跳过
				EOR R3, R3, #0x2000		;ODR异或PC13，取反状态位
NO				STR R3, [R2]
				STR R1, [R0]
				MOV	LR, #EXC_RETURN
				BX LR
				;MOV PC, LR
				ENDP

EXTI1_IRQHandler PROC 	
					;测试向量表顺序代码
				EXPORT  EXTI1_IRQHandler             [WEAK]	
				BX LR
				ENDP
					
                ALIGN 								;填充字节使地址对齐
                END									;整个汇编文件结束