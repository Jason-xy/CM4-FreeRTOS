#include "sys.h"
#include "led.h"
#include "delay.h" 

/************************************************
 ALIENTEK NANO STM32F4������ʵ��1
 �����ʵ�� 
 ����֧�֣�www.openedv.com
 �Ա����̣�http://eboard.taobao.com 
 ��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡSTM32���ϡ�
 ������������ӿƼ����޹�˾  
 ���ߣ�����ԭ�� @ALIENTEK
************************************************/

int main(void)
{ 

	Stm32_Clock_Init(96,4,2,4);//����ʱ��,96Mhz
	delay_init(96);		       //��ʼ����ʱ����
	LED_Init();				   //��ʼ��LEDʱ��
	while(1)
	{
		LED0=0;//LED0��
		LED1=1;//LED1��
		delay_ms(500);
		LED0=1;//LED0��
		LED1=0;//LED1��
		delay_ms(500);	
	}
		
}

/*ʵ����ˮ��*/
/*
 int main(void)
 {	
	u8 LED=0x00;
	u8 i=0;
	
	Stm32_Clock_Init(96,4,2,4);//����ʱ��,96Mhz
	delay_init(96);		       //��ʼ����ʱ����
	LED_Init();				   //��ʼ��LEDʱ��
	 
	while(1)
	{
		for(i=0;i<8;i++)
		{
			LED++;	
			GPIOC->BSRR = LED<<16;
			delay_ms(200);
			LED<<=1;//LED���ε���	
		}
		LED++;	
		GPIOC->BSRR = LED<<16;
		delay_ms(200);
		LED=0xff;//LEDȫ��
		GPIOC->BSRR = LED;
		delay_ms(200);
	}
 }
*/


