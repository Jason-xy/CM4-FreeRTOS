#include "led.h"

//////////////////////////////////////////////////////////////////////////////////	 
//������ֻ��ѧϰʹ�ã�δ��������ɣ��������������κ���;
//ALIENTEK NANO STM32F4������
//LED��������	   
//����ԭ��@ALIENTEK
//������̳:www.openedv.com
//�޸�����:2018/3/27
//�汾��V1.0
//��Ȩ���У�����ؾ���
//Copyright(C) ������������ӿƼ����޹�˾ 2018-2028
//All rights reserved									  
//////////////////////////////////////////////////////////////////////////////////    
    
//LED IO��ʼ��
void LED_Init(void)
{
	 RCC->AHB1ENR|=1<<2;    //ʹ��PORTCʱ��	   
     GPIO_Set(GPIOC,PIN0|PIN1|PIN2|PIN3|PIN4|PIN5|PIN6|PIN7,GPIO_MODE_OUT,GPIO_OTYPE_PP,GPIO_SPEED_100M,GPIO_PUPD_PU); //PC0~7������� 
	 LED0=1;LED1=1;LED2=1;LED3=1;
	 LED4=1;LED5=1;LED6=1;LED7=1;//PC.0~7 ����ߵ�ƽ
}
