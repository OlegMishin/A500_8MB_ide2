# A500_8MB_ide2
Very compact 8MB FastRAM and  BSC-AT-Bus IDE controller for Amiga 500.
Bootable IDE, no needs in a patched scsi.device to be present in Kickstart ROM for autoboot.
Also works with Kickstart 1.3. Able to boot WB 1.3 from HDD. 8MB RAM also detected.

Autoconfig and IDE code based on the great SF2000 project from Jorgen Bilander:
https://github.com/jbilander/SF2000-FW
Many thanks also to 
- Matthias Heinrichs(Matze) for the great 68030TK2 project and BSC-AT-Bus controller
- Matt Harlum (LIV2) for the idea of self flashing of the Autoboot Flash.

Flash ROM contains BSC Oktopussy ROM and can be reflashed on-board. The flashing software tool design is progress.

# CLPD: 
In the design I use Microchip ATF1508 or Altera EPM7128S - true 5V CPLD in 100 pin TQFP package. 
The source code is in verilog. Design tool - Quartus 13.0sp1.

# PCB: 
FOUR layers board. 

# 3D render (work in progress)

![image](https://user-images.githubusercontent.com/81614352/224554563-8b3eaf09-a01d-4ec8-a1b1-b4d80ef90930.png)

Finally got pcb from production, soldered, firmware/software tested - works like a charm!

![image](https://user-images.githubusercontent.com/81614352/227775923-72edef72-1a57-417a-a32f-683ab4e5c025.png)

![image](https://user-images.githubusercontent.com/81614352/233802832-a60085dd-d15f-4e1e-9c69-fde5e32dfa1a.png)


