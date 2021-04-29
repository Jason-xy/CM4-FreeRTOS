#include "FreeRTOS.h"
#include "task.h"

#define START_TASK_PRIO			1
#define START_STK_SIZE			128
void start_task(void * pvParameters);//启动任务函数
TaskHandle_t StartTask_Handler;		//启动任务句柄

#define LEDON_TASK_PRIO			2
#define LEDON_STK_SIZE			128
void LEDON_task(void * pvParameters);//LEDON函数
TaskHandle_t LEDONTask_Handler;		//LEDON任务句柄

#define LEDOFF_TASK_PRIO		3
#define LEDOFF_STK_SIZE			128
void LEDOFF_task(void * pvParameters);//LEDON函数
TaskHandle_t LEDOFFTask_Handler;		//LEDON任务句柄

extern void LEDON(void);
extern void LEDOFF(void);
extern void xPortSysTickHandler(void);

int main(void){
	
	xTaskCreate((TaskFunction_t	) start_task,
				(char*			) "start_task",
				(uint16_t		) START_STK_SIZE,
				(void * 		) NULL,
				(UBaseType_t	) START_TASK_PRIO,
				(TaskHandle_t*	) &StartTask_Handler);
   vTaskStartScheduler();
    while(1){

    }
}

void start_task(void * pvParameters)
{
	//创建LEDON
	xTaskCreate((TaskFunction_t	) LEDON_task,
				(char*			) "LEDON_task",
				(uint16_t		) LEDON_STK_SIZE,
				(void * 		) NULL,
				(UBaseType_t	) LEDON_TASK_PRIO,
				(TaskHandle_t*	) &LEDONTask_Handler);
				
	//创建LEDOFF
	xTaskCreate((TaskFunction_t	) LEDOFF_task,
				(char*			) "LEDOFF_task",
				(uint16_t		) LEDOFF_STK_SIZE,
				(void * 		) NULL,
				(UBaseType_t	) LEDOFF_TASK_PRIO,
				(TaskHandle_t*	) &LEDOFFTask_Handler);
	//删除启动任务
	vTaskDelete(StartTask_Handler); //NULL
}

void LEDON_task(void * pvParameters)
{
	while(1)
	{
		LEDON();
		vTaskDelay(500);
	}
}

void LEDOFF_task(void * pvParameters)
{
	while(1)
	{
		LEDOFF();
		vTaskDelay(1200);
	}
}

void SysTick_Handler(void)
{
  xPortSysTickHandler();
}

