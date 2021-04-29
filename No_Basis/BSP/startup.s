Stack_Size      EQU     0x00000400 ;定义主栈大小
Heap_Size       EQU     0x00000200 ;定义堆大小
RCC_BASE        EQU     0x40023800  ;RCC寄存器基址
PWR_BASE        EQU     0x40007000  ;PWR寄存器基地址
FLASH           EQU     0x40023C00  ;FLASH寄存器基地址
GPIOC_BASE      EQU     0x40020800  ;GPIOC寄存器基地址
SCB_AIRCR       EQU     0xE000ED0C  ;中断控制寄存器
SCB_SHC	    	EQU		0xE000ED18  ;系统中断寄存器
NVIC_ISER0      EQU     0xE000E100  ;中断使能寄存器
	
				EXPORT	GPIOC_BASE

;开辟栈空间
                AREA    STACK, NOINIT, READWRITE, ALIGN=3 ;定义栈空间，不初始化（全0），可读可写，八字节对齐
Stack_Mem       SPACE   Stack_Size
__initial_sp

;开辟堆空间
                AREA    HEAP, NOINIT, READWRITE, ALIGN=3 ;定义堆空间，不初始化（全0），可读可写，八字节对齐
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit

                PRESERVE8							;指示编译器8字节对齐
                THUMB								;指示编译器以后的指令为THUMB指令

				AREA    RESET, CODE, READONLY		;定义只读数据段，标记为RESET，其实放在CODE区，位于0地址
				EXPORT  __Vectors					;在程序中声明一个全局的标号__Vectors，该标号可在其他的文件中引用
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size
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
                DCD     SVC_Handler         ; SVCall Handler
                DCD     0           		; Debug Monitor Handler
                DCD     0                   ; Reserved
                DCD     PendSV_Handler      ; PendSV Handler
                DCD     SysTick_Handler     ; SysTick Handler
                
                ;外部中断向量表
                DCD     0                                 ; Window WatchDog                                        
                DCD     0                                 ; PVD through EXTI Line detection                        
                DCD     0                                 ; Tamper and TimeStamps through the EXTI line            
                DCD     0                                 ; RTC Wakeup through the EXTI line                       
                DCD     0                                 ; FLASH                                           
                DCD     0                                 ; RCC                                             
                DCD     0                                 ; EXTI Line0                                             
                DCD     0                                 ; EXTI Line1                                             
                DCD     0                                 ; EXTI Line2                                             
                DCD     0                                 ; EXTI Line3                                             
                DCD     0                                 ; EXTI Line4                                             
                DCD     0                                 ; DMA1 Stream 0                                   
                DCD     0                                 ; DMA1 Stream 1                                   
                DCD     0                                 ; DMA1 Stream 2                                   
                DCD     0                                 ; DMA1 Stream 3                                   
                DCD     0                                 ; DMA1 Stream 4                                   
                DCD     0                                 ; DMA1 Stream 5                                   
                DCD     0                                 ; DMA1 Stream 6                                   
                DCD     0                                 ; ADC1, ADC2 and ADC3s                            
                DCD     0                                 ; Reserved                                                
                DCD     0                                 ; Reserved                                               
                DCD     0                                 ; Reserved                                             
                DCD     0                                 ; Reserved                                               
                DCD     0                                 ; External Line[9:5]s                                    
                DCD     0                                 ; TIM1 Break and TIM9                   
                DCD     0                                 ; TIM1 Update and TIM10                 
                DCD     0                                 ; TIM1 Trigger and Commutation and TIM11
                DCD     0                                 ; TIM1 Capture Compare                                   
                DCD     0                                 ; TIM2                                            
                DCD     0                                 ; TIM3                                            
                DCD     0                                 ; TIM4                                            
                DCD     0                                 ; I2C1 Event                                             
                DCD     0                                 ; I2C1 Error                                             
                DCD     0                                 ; I2C2 Event                                             
                DCD     0                                 ; I2C2 Error                                               
                DCD     0                                 ; SPI1                                            
                DCD     0                                 ; SPI2                                            
                DCD     0                                 ; USART1                                          
                DCD     0                                 ; USART2                                          
                DCD     0                                 ; Reserved                                          
                DCD     0                                 ; External Line[15:10]s                                  
                DCD     0                                 ; RTC Alarm (A and B) through EXTI Line                  
                DCD     0                                 ; USB OTG FS Wakeup through EXTI line                        
                DCD     0                                 ; Reserved                  
                DCD     0                                 ; Reserved                 
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved                                   
                DCD     0                                 ; DMA1 Stream7                                           
                DCD     0                                 ; Reserved                                             
                DCD     0                                 ; SDIO                                            
                DCD     0                                 ; TIM5                                            
                DCD     0                                 ; SPI3                                            
                DCD     0                                 ; Reserved                                           
                DCD     0                                 ; Reserved                                           
                DCD     0                                 ; Reserved                   
                DCD     0                                 ; Reserved                   
                DCD     0                                 ; DMA2 Stream 0                                   
                DCD     0                                 ; DMA2 Stream 1                                   
                DCD     0                                 ; DMA2 Stream 2                                   
                DCD     0                                 ; DMA2 Stream 3                                   
                DCD     0                                 ; DMA2 Stream 4
                DCD     0                                 ; Reserved  
                DCD     0                                 ; Reserved  
                DCD     0                                 ; Reserved                                              
                DCD     0                                 ; Reserved                                               
                DCD     0                                 ; Reserved                                               
                DCD     0                                 ; Reserved                                               
                DCD     0                                 ; USB OTG FS                                      
                DCD     0                                 ; DMA2 Stream 5                                   
                DCD     0                                 ; DMA2 Stream 6                                   
                DCD     0                                 ; DMA2 Stream 7                                   
                DCD     0                                 ; USART6                                           
                DCD     0                                 ; I2C3 event                                             
                DCD     0                                 ; I2C3 error                                             
                DCD     0                                 ; Reserved                     
                DCD     0                                 ; Reserved                       
                DCD     0                                 ; Reserved                         
                DCD     0                                 ; Reserved                                    
                DCD     0                                 ; Reserved  
                DCD     0                                 ; Reserved				                              
                DCD     0                                 ; Reserved
                DCD     0                                 ; FPU
                DCD     0                                 ; Reserved
		        DCD     0                                 ; Reserved
		        DCD     0                                 ; SPI4
				DCD     0                                 ; SPI5
__Vectors_End
__Vectors_Size  EQU  __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY		;定义代码段，标记为.text
				ENTRY
;复位中断服务函数
Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
        IMPORT  __main
                LDR     R0, =0xE000ED88    ; 使能浮点运算 CP10,CP11
                LDR     R1,[R0]
                ORR     R1,R1,#(0xF << 20)
                STR     R1,[R0]
                BL      SysTickConfig				
                BL      GPIOConfig
                LDR     R0, =__main
                BX      R0
                ENDP
				
SVC_Handler     PROC
                EXPORT  SVC_Handler                [WEAK]
                B       .
                ENDP					
PendSV_Handler  PROC
                EXPORT  PendSV_Handler             [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler            [WEAK]
                B       .
                ENDP
					
				EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit
					
;时钟初始化，提供100MHz SysTick
SysTickConfig   PROC
                CPSID I ;关中断

                ;RCC->CR|=0x00000001    设置HISON,开启内部高速RC振荡
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x00 ;定位RCC_CR
                LDR R1, [R0]
                ORR R1, R1, #0x01
                STR R1, [R0]

                ;RCC->CFGR=0x00000000   CFGR清零
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x08 ;定位RCC_CFGR
                MOV R1, #0x00
                STR R1, [R0]

                ;RCC->CR&=0xFEF6FFFF    HSEON,CSSON,PLLON清零
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x00 ;定位RCC_CR
                LDR R1, [R0]
				MOV R2, #0
                ADD R2, R2, #0xFE000000
				ADD R2, R2, #0xF60000
				ADD R2, R2, #0xFF00
				ADD R2, R2, #0xFF
				AND R1, R1, R2
                STR R1, [R0]

                ;RCC->PLLCFGR=0x24003010    PLLCFGR恢复复位值
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x04 ;定位RCC_PLLCFGR
                MOV R1, #0x24000000
				ADD R1, R1 ,#0x3000
				ADD R1, R1 ,#0x10
                STR R1, [R0]

                ;RCC->CR&=~(1<<18)  HSEBYP清零,关闭外部晶振
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x00 ;定位RCC_CR
                LDR R1, [R0]
                AND R1, R1, #0xFFFBFFFF
                STR R1, [R0]

                ;RCC->CIR=0x00000000    禁止RCC时钟中断
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x0C ;定位RCC_CIR
                MOV R1, #0x00000000
                STR R1, [R0]

                ;plln=100, pllm=8, pllp=2, pllq=4
                ;RCC->CR|=1<<16     HSE 开启
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x00 ;定位RCC_CR
                LDR R1, [R0]
                ORR R1, R1, #0x10000
                STR R1, [R0]

                ;等待HSE开启

                ;RCC->APB1ENR|=1<<28    电源接口时钟使能
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x40 ;定位RCC->APB1ENR
                LDR R1, [R0]
                ORR R1, R1, #0x10000000
                STR R1, [R0]

                ;PWR->CR|=3<<14     高性能模式,时钟可到100Mhz
                LDR R0, =PWR_BASE
                ADD R0, R0, #0x00 ;定位PWR_CR
                LDR R1, [R0]
                ORR R1, R1, #0xC000
                STR R1, [R0]

                ;RCC->CFGR|=(0<<4)|(4<<10)|(0<<13)  HCLK 不分频;APB1 2分频;APB2 1分频
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x08 ;定位RCC_CFGR
                LDR R1, [R0]
                ORR R1, #0x1000
                STR R1, [R0]

                ;RCC->CR&=~(1<<24)  关闭主PLL
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x00 ;定位RCC_CR
                LDR R1, [R0]
                AND R1, R1, #0xFEFFFFFF
                STR R1, [R0]

                ;RCC->PLLCFGR=8|(100<<6)|(((2>>1)-1)<<16)|(4<<24)|(1<<22)   配置主PLL,PLL时钟源来自HSE
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x04 ;定位RCC_PLLCFGR
                MOV R1, #0x04600000
				ADD R1, R1, #0x08
				ADD R1, R1, #0x40000
                STR R1, [R0]

                ;RCC->CR|=1<<24 打开主PLL
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x00 ;定位RCC_CR
                LDR R1, [R0]
                ORR R1, R1, #0x1000000
                STR R1, [R0]

                ;FLASH->ACR|=1<<8   指令预取使能
		        ;FLASH->ACR|=1<<9   指令cache使能.
		        ;FLASH->ACR|=1<<10  数据cache使能.
		        ;FLASH->ACR|=3<<0   4个CPU等待周期. 
                LDR R0, =FLASH
                ADD R0, R0, #0x00 ;定位FLASH->ACR
                LDR R1, [R0]
				MOV R2, #0
				ADD R2, R2, #0x700
				ADD R2, R2, #0x3
                ORR R1, R1, R2
                STR R1, [R0]

                ;RCC->CFGR&=~(3<<0) 清零
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x08 ;定位RCC_CFGR
                LDR R1, [R0]
                AND R1, #0xFFFFFFFC
                STR R1, [R0]

                ;RCC->CFGR|=2<<0    选择主PLL作为系统时钟
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x08 ;定位RCC_CFGR
                LDR R1, [R0]
                ORR R1, #0x2
                STR R1, [R0]

                ;等待PLL作为系统时钟

                ;初始化NVIC分组SCB->AIRCR [10:8]:000  复位位 000
                LDR R0, =SCB_AIRCR
				LDR R1, [R0]
				AND R1, R1,#0xFFFFF8FF
				STR R1, [R0]

                ;初始化NVIC使能寄存器NVIC->ISER[0] [6]:1  复位位 全0
				LDR R0, =NVIC_ISER0
				LDR R1, [R0]
				ORR R1, R1,#(1<<6)
				STR R1, [R0]

                ;初始化SysTick中断优先级
				LDR R0, =SCB_SHC
				LDR R1, [R0]
				MOV R1, #0x0
				STR R1, [R0]

                CPSIE I ;开中断

                BX LR
				ENDP

;GPIO初始化
GPIOConfig      PROC
                ;开启GPIOC时钟
                LDR R0, =RCC_BASE
                ADD R0, R0, #0x30   ;定位RCC_AHB1ENR
                LDR R1, [R0]
				ORR R1, R1, #0x4    ;GPIOC
			    STR R1, [R0] 

                ;GPIOC_MODER设置为输出
                LDR R0, =GPIOC_BASE
                ADD R0, R0, #0x00   ;定位到GPIOC_MODER
                LDR R1, [R0]
				MVN R2, #0xC000000
                ADD R1, R1, r2
                ORR R1, R1, #0x4000000
                STR R1, [R0]

                ;GPIOC_OTYPER设置为推挽输出
                LDR R0, =GPIOC_BASE
                ADD R0, R0, #0x04   ;定位到GPIOC_OTYPER
                LDR R1, [R0]
				MVN R2, #0x2000
                ADD R1, R1, R2
                ORR R1, R1, #0x00
                STR R1, [R0]

                ;GPIOC_OSPEEDR设置为50hz
                LDR R0, =GPIOC_BASE
                ADD R0, R0, #0x08   ;定位到GPIOC_OSPEEDR
                LDR R1, [R0]
                MVN R2, #0x2000
                ADD R1, R1, R2
                ORR R1, R1, #0x8000000
                STR R1, [R0]

                ;GPIOC_PUPDR设置为下拉
                LDR R0, =GPIOC_BASE
                ADD R0, R0, #0x0C   ;定位到GPIOC_PUPDR
                LDR R1, [R0]
                MVN R2, #0x2000
                ADD R1, R1, R2
                ORR R1, R1, #0x8000000
                STR R1, [R0]

                BX LR
				ENDP

LEDOFF			PROC
				EXPORT LEDOFF                                                                                                                                                                                                                                                                                                                                                   
				LDR R0, =GPIOC_BASE
                ADD R0, R0, #0x14   ;定位GPIOC_ODR
                LDR R1, [R0]
				ORR  R1, R1, #(1<<13)
			    STR R1, [R0]

				BX LR
				ENDP

LEDON			PROC
				EXPORT	LEDON
				LDR R0, =GPIOC_BASE
                ADD R0, R0, #0x14   ;定位GPIOC_ODR
                LDR R1, [R0]
				MVN R2, #(1<<13)
				AND R1, R1, R2 
			    STR R1, [R0]

				BX LR
				ENDP
				
				ALIGN 								;填充字节使地址对齐
                END									;整个汇编文件结束
				