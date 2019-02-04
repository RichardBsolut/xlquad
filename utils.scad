use <./lib/bcad.scad>
include <./config.scad>

module xl320Connector(h=3.25,extraPlay=0) {
    cylinder(d1=5-fit_clearance,d2=4-fit_clearance,h=0.5);
    cylinder(d=4-fit_clearance+extraPlay,h=h-0.5);
    up(h-0.5)
        cylinder(d1=4-fit_clearance+extraPlay,d2=4-moving_clearance*2,h=0.5);
}

module motorConnect() {
    xrot(180)
        xl320Connector();
    xl320Connector();
}

module bearingCut(extraPlay=0,od=5) {
    move(z=-10) {
        cylinder(d=BEARING_D+fit_clearance+extraPlay,h=10);
        cylinder(d=od,h=20);
    }
}
