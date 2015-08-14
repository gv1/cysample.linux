all: "Bootloadable\ Blinking\ LED.elf"

main.o: main.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=./main.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c main.c -o main.o

cyfitter_cfg.o: cyfitter_cfg.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=.cyfitter_cfg.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c cyfitter_cfg.c -o cyfitter_cfg.o

cybootloader.o: cybootloader.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=cybootloader.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c cybootloader.c -o cybootloader.o

cymetadata.o: cymetadata.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=cymetadata.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c cymetadata.c -o cymetadata.o

Bootloadable.o: Bootloadable.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=Bootloadable.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c Bootloadable.c -o Bootloadable.o

PWM.o: PWM.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=PWM.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c PWM.c -o PWM.o

PWM_PM.o: PWM_PM.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=PWM_PM.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c PWM_PM.c -o PWM_PM.o

Clock.o: Clock.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=Clock.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c Clock.c -o Clock.o

P1_6.o: P1_6.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=P1_6.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c P1_6.c -o P1_6.o

Cm0Start.o: Cm0Start.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=Cm0Start.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c Cm0Start.c -o Cm0Start.o

CyBootAsmGnu.o: CyBootAsmGnu.s
	arm-none-eabi-as -mcpu=cortex-m0 -mthumb -I. -alh=CyBootAsmGnu.lst -g -o CyBootAsmGnu.o CyBootAsmGnu.s

CyFlash.o: CyFlash.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=CyFlash.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c CyFlash.c -o CyFlash.o

CyLib.o: CyLib.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=CyLib.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c CyLib.c -o CyLib.o

cyPm.o: cyPm.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=cyPm.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c cyPm.c -o cyPm.o

cyutils.o: cyutils.c
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -Wno-main -I. -Wa,-alh=cyutils.lst -g -D DEBUG -Wall -ffunction-sections -O0 -c cyutils.c -o cyutils.o

"Bootloadable\ Blinking\ LED.a": cyfitter_cfg.o Bootloadable.o PWM.o PWM_PM.o Clock.o P1_6.o CyBootAsmGnu.o CyFlash.o CyLib.o cyPm.o cyutils.o
	arm-none-eabi-ar -rs "Bootloadable Blinking LED.a" cyfitter_cfg.o Bootloadable.o PWM.o PWM_PM.o Clock.o P1_6.o CyBootAsmGnu.o CyFlash.o CyLib.o cyPm.o cyutils.o
"Bootloadable\ Blinking\ LED.elf": "Bootloadable\ Blinking\ LED.a" main.o cybootloader.o cymetadata.o Cm0Start.o
	arm-none-eabi-gcc -Wl,--start-group -o "Bootloadable Blinking LED.elf" main.o cybootloader.o cymetadata.o Cm0Start.o "Bootloadable Blinking LED.a" "CyComponentLibrary.a" -mcpu=cortex-m0 -mthumb -g -ffunction-sections -O0 "-Wl,-Map,Bootloadable Blinking LED.map" -T cm0gcc.ld -specs=nano.specs -Wl,--gc-sections -Wl,--end-group
	arm-none-eabi-objcopy -O ihex "Bootloadable Blinking LED.elf" "Bootloadable Blinking LED.hex"
	# cyelftool.exe -B "Bootloadable\ Blinking\ LED.elf" --flash_row_size 128 --flash_size 32768 --flash_array_size 32768
	# cyelftool.exe -S "Bootloadable\ Blinking\ LED.elf"

BOOTLOADER=../hex2cyacd/test/UART_Bootloader.elf
TSIZE=$(shell arm-none-eabi-size $(BOOTLOADER) | grep UART_Bootloader | awk '{ print $$1 }')
cyacd:
	perl ../hex2cyacd/ihex2cyacd.pl $(TSIZE) 128 "Bootloadable Blinking LED.hex" "Bootloadable Blinking LED_new.cyacd"


clean:
	-rm *.o Boot*.a *.elf *.lst *.hex *.map *cyacd 
