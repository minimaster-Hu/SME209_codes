
iverilog -o testbench.vvp Simulation_Source/tb_MCycle.v Design_Source/MCycle*.v

if %errorlevel% neq 0 (
    rem echo "************** has bug! ***************"
    pause
    exit /b
)

vvp testbench.vvp 

gtkwave testbench.wave

if %errorlevel% neq 0 (
    rem echo "************** has bug! ***************"
    pause
    exit /b
)

