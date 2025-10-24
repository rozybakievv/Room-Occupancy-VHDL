# Project - Room Occupancy Tracking System

Tracking of the occupancy of a room with a max_capacity output signal implementend in VHDL. When max capacity of the room is reached, max_capacity is set to `1`. Simulation done in ModelSim and synthesization in Vivado. The design runs on a Artix 7 device : xc7a100tcsg324-1 FPGA development board.

## The files

`room.vhd` : Main VHDL program file. Counts the occupancy of a room with input signals clk, reset, photo_enter, photo_exit and set_capacity and activates an output max_capacity when occupancy matches set_capacity

`room_tb.vhd` : Testbench program that simulates the frequency of a clock and tests all the possible scenarios to see if the program behaves correctly. Signals are to be verified in ModelSim.

## How to execute the code

### Simulation (ModelSim):

1. Open a terminal on a linux machine in a Concordia laboratory and navigate to the project folder using the `cd` command

2. Enter following commands in order:
`source /CMC/ENVIRONMENT/modelsim.env`
`vlib work`
`vcom room.vhd`
`vcom room_tb.vhd`
`vsim -novopt room_tb`

3. After ModelSim loads up, open the command line and enter the following commands:
`add wave *`
`run 700 ns`

### Implementation / Synthesis (Vivado):

1. Open a terminal on a linux machine in a Concordia laboratory and navigate to the project folder using the `cd` command

2. Enter those commands in the terminal in order:
`source /CMC/tools/xilinx/Vivado_2018.2/Vivado/2018.2/
settings64_CMC_central_license.csh` (in one line)
`vivado &`

3. Create a new project, click next two times, select RTL Project and click next

4. Add the room.vhd to the source files and click next two times

5. In the Default part pane, specify Family : Artix 7 device : xc7a100tcsg324-1 and click next then finish

6. Click on run synthesis then ok and when synthesis is complete, run implementation


