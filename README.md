# A500_8MB_ide2
Very compact 8MB FastRAM and  BSC-AT-Bus IDE controller for Amiga 500.
Bootable IDE, no needs a patched scsi.device to be present in Kickstart ROM for autoboot.

Autoconfig and IDE code based on the great SF2000 project from Jorgen Bilander:
https://github.com/jbilander/SF2000-FW
Many thanks also to 
- Matthias Heinrichs(Matze) for the great 68030TK2 project and BSC-AT-Bus controller
- Matt Harlum (LIV2) for the idea of self flashing of the Autoboot Flash.

# CLPD: 
In the design I use Microchip ATF1508 true 5V CPLD in 100 pin TQFP package. The source code is in verilog. Design tool - Quartus 13.0sp1.

# PCB: 
FOUR layers board. 

# 3D render (work in progress)

![image](https://user-images.githubusercontent.com/81614352/224554563-8b3eaf09-a01d-4ec8-a1b1-b4d80ef90930.png)

