#include "led.h"

//////////////////////////////////////////////////////////////////////////////////	 
//本程序只供学习使用，未经作者许可，不得用于其它任何用途
//ALIENTEK NANO STM32F4开发板
//LED驱动代码	   
//正点原子@ALIENTEK
//技术论坛:www.openedv.com
//修改日期:2018/3/27
//版本：V1.0
//版权所有，盗版必究。
//Copyright(C) 广州市星翼电子科技有限公司 2018-2028
//All rights reserved									  
//////////////////////////////////////////////////////////////////////////////////    
    
//LED IO初始化
void LED_Init(void)
{
	 RCC->AHB1ENR|=1<<2;    //使能PORTC时钟	   
     GPIO_Set(GPIOC,PIN0|PIN1|PIN2|PIN3|PIN4|PIN5|PIN6|PIN7,GPIO_MODE_OUT,GPIO_OTYPE_PP,GPIO_SPEED_100M,GPIO_PUPD_PU); //PC0~7推挽输出 
	 LED0=1;LED1=1;LED2=1;LED3=1;
	 LED4=1;LED5=1;LED6=1;LED7=1;//PC.0~7 输出高电平
}
