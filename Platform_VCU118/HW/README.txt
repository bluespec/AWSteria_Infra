mkAWSteria_HW_EMPTY.v

    This is an empty Verilog module with the same port list as any
    module compiled with bsc from any AWSteria_HW.bsv module with
    standard interface in
        Include_API/AWSteria_HW_IFC.bs

    It is only used as a placeholder for any actual AWSteria_HW.bsv
    module in the Vivado Block Design project AWSteria_HW_reclocked/
    (see below).

AWSteria_HW_reclocked/

    This is a Vivado Block Design project that creates a "reclocking
    layer" for AWSteria_HW_IFC.bsv, i.e., it creates a module with the
    AWSteria_HW_IFC.bsv interface, inside which it:
    - instantiates a module with the AWSteria_HW_IFC.bsv interface
    - creates clock crossings between the outer and inner interfaces
    The outer module receives clocks at 250 MHz and (ignored)
    The inner module receives clocks at 100 MHz and 50 MHz

    This allows the user's design to run at a slower clock than 250 MHz.

    In Vivado, the "Generate Block Deign" action creates:

        AWSteria_HW_reclocked/AWSteria_HW_reclocked.srcs/sources_1/bd

    which is copied into example_AWSteria_HW_reclocked/src/bd (see
    below).

    This Block Design project step does not have to be repeated unless we
    want to change the clock speed config.

    TODO: This Block Design could be coded as a Vivado Tcl script,
          instead of using the Vivado GUI.

example_AWSteria_HW_reclocked/

    This is a template directory that can be used in the Garnet flow
    just like the standard Garnet example.  It has the following
    structure:

        example_AWSteria_HW_reclocked/
        ├── Makefile
        ├── src
        │   ├── bd/                [This is copied from AWSteria_HW_reclocked, see above]
        │   ├── synchronizers.v
        │   └── top_garnet.v
        └── tcl
            └── build.tcl

    To run your own AWSteria design,
    - Add your actual mkAWSteria_HW.v source, and sources for hierarchy below it.
        These can be added directly to src/, or in a separate sub-directory, ...
    - Edit tcl/build.tcl to 'add_files' all your sources.
    - Copy example_AWSteria_HW_reclocked into your clone of the garnet/ repo
    - There (in example_AWSteria_HW_reclocked), 'make'
        to create the partial-reconfig bit file to be loaded onto your
        VCU118 using partial reconfig.
