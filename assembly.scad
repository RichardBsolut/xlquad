use <./lib/bcad.scad>
include <./config.scad>
use <./body.scad>
use <./leg.scad>
use <./abductor.scad>



module helperLegPos() {
    move(y=36,x=27) {        
        children();
        move(x=-105)
            children();
    }
}

bodyAsm();

xyflip_copy()
move(y=36,x=27) {
    xrot(-90) yrot(90)
        abductorArm();

    move(x=52.5)
    xrot(-90) yrot(-90)
        abductorSupport();
}

yflip_copy()
helperLegPos() {
    xrot(-90)
    move(x=24+ABDUCTOR_H,y=24,z=-3+9)
        zrot(180) legAsm();
}