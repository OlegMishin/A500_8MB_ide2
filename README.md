# A500_8MB_ide2
Very compact 8MB FastRAM and BSC-AT-Bus IDE controller for Amiga 500.
- Bootable IDE, no needs in a patched scsi.device to be present in Kickstart ROM for autoboot.
- Supports Kickstart from 1.3 and higher.
- Able to boot WB 1.3 and higher from HDD. 8MB RAM also detected in WB 1.3.

Autoconfig and IDE code based on the great SF2000 project from Jorgen Bilander:
https://github.com/jbilander/SF2000-FW

Many thanks also to 
- Matthias Heinrichs(Matze) for the great 68030TK2 project and BSC-AT-Bus controller
- Matt Harlum (LIV2) for the idea of self flashing of the Autoboot Flash.

Flash ROM contains BSC Oktopussy ROM and can be reflashed on-board. The flashing software tool is in "software" folder.

Works with A500. Doesn't work with CDTV due to DMAC on board (when I have a chance to test, I will update FW for CDTV).

# CLPD: 
In the design I use Microchip ATF1508 or Altera EPM7128S - true 5V CPLD in 100 pin TQFP package. 
The source code is in verilog. Design tool - Quartus 13.0sp1.
The below CPLD can be used in the project:

ATF1508AS (TQFP-100) or EPM7128STC100/STI100 with speed grade up to 15ns(tested).
Also 25ns should work(not yet tested). 

# PCB: 
FOUR layers board. 

# 3D render (work in progress)

![image](https://user-images.githubusercontent.com/81614352/224554563-8b3eaf09-a01d-4ec8-a1b1-b4d80ef90930.png)

Finally got pcb from production, soldered, firmware/software tested - works like a charm!

![image](https://user-images.githubusercontent.com/81614352/227775923-72edef72-1a57-417a-a32f-683ab4e5c025.png)

![image](https://user-images.githubusercontent.com/81614352/233802832-a60085dd-d15f-4e1e-9c69-fde5e32dfa1a.png)

Booted Workbench 1.3

![image](https://user-images.githubusercontent.com/81614352/236283699-27726da8-3ded-4aaf-a3cb-83a00913ba4f.png)



