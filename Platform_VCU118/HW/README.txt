Notes on files in this directory.

AWSteria_Infra's VCU specific HW:
    AWSteria_HW_Platform.bsv

Vivado project to create clock-divider from 250 MHz input clock to
with 5 output clocks at slower speeds.  This Vivado project is not
part of the subsequent flow, and is kept here for reference in case of
future modifications.

    AWSteria_ClockDiv/

A copy of this directory is in the template directory below:

    AWSteria_ClockDiv/AWSteria_ClockDiv.srcs/sources_1/bd/

Template directory for Garnet flow:
    example_AWSteria_HW/

Makefile to load Garnet's 'empty.bit' into FPGA, using program_fpga Vivado tcl script:
    Load_Shell.mk
    program_fpga*

// ================================================================
OLD STUFF

Vivado project to create 100 MHz reclocking layer and 25 MHz reclocking layer:
    AWSteria_HW_reclocked/
    AWSteria_HW_reclocked_25MHz/

Some Verilog used in reclocking layers:
    synchronizers.v

Template directory for Garnet flow, no reclocking (full speed 250 MHz):
    example_AWSteria_HW/

Template directory for Garnet flow, reclocking at 100 MHz
    example_AWSteria_HW_reclocked_100MHz/
Copies .bd directory from 'AWSteria_HW_reclocked/' above.

Template directory for Garnet flow, reclocking at 25 MHz
    example_AWSteria_HW_reclocked_25MHz/
Copies .bd directory from 'AWSteria_HW_reclocked_25MHz/' above.
