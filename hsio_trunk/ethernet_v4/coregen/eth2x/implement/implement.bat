
rem Clean up the results directory
rmdir /S /Q results
mkdir results

echo 'Synthesizing sample design with XST'
xst -ifn xst.scr
copy eth2x_example_design.ngc .\results\eth2x_top.ngc

rem  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
copy ..\example_design\eth2x_block.ucf results\eth2x_top.ucf

cd results

echo 'Running ngdbuild'
ngdbuild -uc eth2x_top.ucf eth2x_top

echo 'Running map'
map eth2x_top -o mapped.ncd

echo 'Running par'
par -n 0 -s 1 -ol high -w mapped.ncd routed.dir mapped.pcf
copy /B routed.dir\*.ncd routed.ncd

echo 'Running trce'
trce -u -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level VHDL model'
netgen -ofmt vhdl -rpw 500 -tpw 500 -sim -pcf mapped.pcf -dir . -tm eth2x_example_design -w routed.ncd routed.vhd
