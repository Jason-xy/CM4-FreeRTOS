# 基于CM4的FreeRTOS移植（HAL）

## 准备FreeRTOS源文件

1. 官网下载FreeRTOS-LTS源码

2. 找到目录`FreeRTOS-LTS\FreeRTOS\FreeRTOS-Kernel`，该目录下既为FreeRTOS内核源码。

   ![image.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/image.png)

   `include`文件夹下为头文件依赖。

   `portable`文件夹下为开发环境与硬件相关代码。

3. 在`portable`下保留`MemMang`内存管理文件夹、`RVDS`硬件接口文件夹。

   ![imaged8d23d4fe0963c90.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/imaged8d23d4fe0963c90.png)

## 在工程中添加FreeRTOS源码

1. 在工程中新建`FreeRTOS-Core`和`FreeRTOS-Port`两个分组，并加入以下源文件。

   ![image56dd187ed97bcdef.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/image56dd187ed97bcdef.png)

2. 在工程中添加Free-RTOS头文件路径

   ![image9f79321045177b5f.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/image9f79321045177b5f.png)

## 编译及报错解决

1. **首次编译**，未找到配置文件`FreeRTOSConfig.h`

   ![image6912cf4587c83f98.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/image6912cf4587c83f98.png)

   该文件主要作用是配置FreeRTOS功能，根据应用场景定制裁剪操作系统。

   可以参照官方Demo来编写该文件，配置操作系统功能。

   如下便是部分功能开关：

   ![image7e2f25d0d6d2722b.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/image7e2f25d0d6d2722b.png)

2. 再次编译，`PendSV_Handler`函数与`SVC_Handler`函数出现重定义。

   ![image7d89ce431753675b.png](https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/image7d89ce431753675b.png)

   `SVC_Handler`用于上下文切换时恢复现场，开始执行当前最高优先级的任务。

   `PendSV_Handler`用于上下文切换，保存以及恢复现场。

   在中断服务函数定义文件中注释掉这两个函数即可。

再次编译发现不会报错了，说明已经可以成功蒙过编译器了，至少在目前看来程序相关依赖已经基本搞定。

**（实际上还有一个很重要的部分没完成）**

## 尝试调用FreeRTOS的SysCall

在`main.c`中引用`FreeRTOS.h`和`task.h`头文件。

添加以下任务：

```c
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
```

任务函数：

```c
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
		HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
		vTaskDelay(500);
	}
}

void LEDOFF_task(void * pvParameters)
{
	while(1)
	{
		HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
		vTaskDelay(120);
	}
}
```

在主函数中调用以下代码启动操作系统和任务：

```c
xTaskCreate((TaskFunction_t	) start_task,
				(char*			) "start_task",
				(uint16_t		) START_STK_SIZE,
				(void * 		) NULL,
				(UBaseType_t	) START_TASK_PRIO,
				(TaskHandle_t*	) &StartTask_Handler);
vTaskStartScheduler();
```

## 注意

然后发现程序跑了一半跑不动了！

在执行`vTaskDelay()`后任务退出就绪队列，就再也无法执行了。

单步跟踪可以发现卡在了下面这段代码：

```asm
SysTick_Handler PROC
                EXPORT  SysTick_Handler            [WEAK]
                B       .
                ENDP
```

很显然是Tick出了问题，自始至终我们似乎都没有给系统配置过时基，那么裸板时钟触发SysTick后找不到我们编写的`SysTick_Handler`服务函数，只能跳转在[WEAK]属性的函数中开始无限循环。

很显然我们应该自己写一个`SysTick_Handler`来对接操作系统的心跳接口。

代码实现如下：

```c
void SysTick_Handler(void)
{
  xPortSysTickHandler();
  HAL_IncTick();
}
```

## 完成

然后就可以愉快地跑起来了！！

[<img src="https://wpcos-1300629776.cos.ap-chengdu.myqcloud.com/Gallery/2021/04/27/IMG_20210427_202401.md.jpg" alt="IMG_20210427_202401.md.jpg" style="zoom:50%;" />](https://gallery.jason-xy.cn/image/zsJ2)