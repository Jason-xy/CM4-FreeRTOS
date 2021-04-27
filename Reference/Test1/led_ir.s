                PRESERVE8							;ָʾ������8�ֽڶ���
                THUMB								;ָʾ�������Ժ��ָ��ΪTHUMBָ��								

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
				AREA    RESET, CODE, READONLY		;����ֻ�����ݶΣ����ΪRESET����ʵ����CODE����λ��0��ַ
				EXPORT  __Vectors					;�ڳ���������һ��ȫ�ֵı��__Vectors���ñ�ſ����������ļ�������
					
__Vectors       DCD     __initial_sp        ;��ǰ��ַд��һ����(32bit)���ݣ�ֵΪ0x00000000��ʵ����Ӧ������ջ����ַ 
                DCD     Reset_Handler       ;��ǰ��ַд��һ����(32bit)���ݣ�ֵΪReset_Handler��ֵ����������ڵ�ַ
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
				DCD		EXTI1_IRQHandler	; EXTI Line 1 ����������˳�����
					
				AREA    |.text|, CODE, READONLY		;�������Σ����Ϊ.text
				ENTRY
				
Reset_Handler   PROC								;���̵Ŀ�ʼ 
				EXPORT  Reset_Handler	[WEAK]		;[WEAK] �����壬��˼������ڱ�Ҳ����ñ��(����)��������ʱ�ñ𴦵ĵ�ַ��
				;LED PB12 KEY PA0
				
				CPSID I ;���ж�
				
				; 1����RCC��ʱ��
				LDR R0, =RCC_APB2ENR;��λRCC_APB2ENR
				LDR R1, [R0]
				ORR R1, R1, #0x15	;GPIOC��GPIOB��GPIOA���ա�GPIOAFIO	10101 = D
				STR R1, [R0]
				
				; 2����GPIOC13����Ϊ�������50Mhz [23:20]:0011  ��λλ 0100
				LDR R0, =GPIOC_CRH
				LDR R1, [R0]
				EOR R1, R1, R1;���
				ORR R1, R1,#(3<<4*5)
				STR R1, [R0]
				
				; 3����GPIOA0����Ϊ�������� [19:16]:1000  ��λλ 0100
				LDR R0, =GPIOA_CRL
				LDR R1, [R0]
				EOR R1, R1, R1;���
				ORR R1, R1,#(8<<4*0)
				STR R1, [R0]				
				
				; 4����ʼ��NVIC����SCB->AIRCR [10:8]:000  ��λλ 000
				LDR R0, =SCB_AIRCR
				LDR R1, [R0]
				AND R1, R1,#0xFFFFF8FF
				STR R1, [R0]
				
				; 5����ʼ��NVICʹ�ܼĴ���NVIC->ISER[0] [6]:1  ��λλ ȫ0
				LDR R0, =NVIC_ISER0
				LDR R1, [R0]
				ORR R1, R1,#(1<<6)
				STR R1, [R0]
				
				; 7����ʼ��NVIC���ȼ��Ĵ���NVIC->IP[6] [6]:1  ��λλ ȫ0
				LDR R0, =NVIC_IP6
				LDR R1, [R0]
				EOR R1, R1, R1;ȫ0��ֱ��������ȼ�
				STR R1, [R0]
				
				; 8������AFIO_EXTICR1��ѡ��PA0Ϊ�������� [3:0]:0000  ��λλ 0000
				LDR R0, =AFIO_EXTICR1
				LDR R1, [R0]
				EOR R1, R1, R1;���
				STR R1, [R0]
				
				; 9������EXTI_FTSR������0���½��ش��� [0]:1  ��λλ 0000
				LDR R0, =EXTI_FTSR
				LDR R1, [R0]
				ORR R1, R1, #1
				STR R1, [R0]
				
				; 10������EXTI_IMR������0���ж����� [0]:1  ��λλ 0000
				LDR R0, =EXTI_IMR
				LDR R1, [R0]
				ORR R1, R1, #1
				STR R1, [R0]
				
				CPSIE I ;���ж�
Loop				
				B Loop
                ENDP
					;���̵Ľ���

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
				AND R1, R1, #1	;ֻ�������һλ
				CMP	R1, #1
				BNE	NO			;�������0�����ʾ���һλ��1��������жϣ��������ȣ���û���жϲ�����������
				EOR R3, R3, #0x2000		;ODR���PC13��ȡ��״̬λ
NO				STR R3, [R2]
				STR R1, [R0]
				MOV	LR, #EXC_RETURN
				BX LR
				;MOV PC, LR
				ENDP

EXTI1_IRQHandler PROC 	
					;����������˳�����
				EXPORT  EXTI1_IRQHandler             [WEAK]	
				BX LR
				ENDP
					
                ALIGN 								;����ֽ�ʹ��ַ����
                END									;��������ļ�����