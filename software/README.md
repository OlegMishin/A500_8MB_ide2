# Flashem software tool

The tool used to flash onboard FlashROM. I use "oktapussy.bin" located in ROM folder.
It is provided as a Workbench floppy to be loaded by real Amiga.

As the tool created to flash only A500_8MB_IDE2 board, it has some limitations: 
- Only 32K ROM is supported
- Start address is fixed to 0x00EE0000

Usage: flashem -<argument>
the arguments are:
-i - show Flash ID. E.g. it returns 0xBFB5 for SST39SF010A
-e - erase flash.
-d [shift] - dump 256 bytes Flash from [shift] address
-r [filename] - read flash to 32K file [filename]
-w [filename] - write file [filename] to flash
-v [filename] - Compare flash with file [filename]

How to use.

1. Set JP3 (Flash Programming) jumper as below

   ![image](https://github.com/OlegMishin/A500_8MB_ide2/assets/81614352/8398f70f-a68f-4e5b-ae45-46594e5fe4d7)

2. Load Workbench from "A500_8MB_IDE2.adf". Open  AmigaShell.
3. Check Flash ID with "-i" command. It should return a valid ID for the Flach IC mounted.
   ![image](https://github.com/OlegMishin/A500_8MB_ide2/assets/81614352/43d48930-3dda-4279-a6ba-432a2a977721)

4. Check if the Flash is erased with "-d 0" command. It shall return all 0xFF as below.
   ![image](https://github.com/OlegMishin/A500_8MB_ide2/assets/81614352/8a90e450-5820-47e1-9794-662bcf2bbfbf)

   If the Flash is not empty, erase it with "-e" command. Than check again whether erase was done.
   
6. Write flash with "oktapussy.bin"
   ![image](https://github.com/OlegMishin/A500_8MB_ide2/assets/81614352/038f777e-6a3c-4123-9170-99901fdd40d6)

7. Power off, set jumpers as for normal operation. Now it is ready to boot from HDD/CF.

   
   











