use <./lib/bcad.scad>
use <./vitamins.scad>
use <./utils.scad>
include <./config.scad>


module abductorPin() {
    cylinder(d=5-fit_clearance,h=0.5);
    cylinder(d=4-fit_clearance,h=2.5);
    cylinder(d=3-fit_clearance*2,h=6);
}


module xl320SideConnect(h=2.25) {    
    hull_around() {
        cylinder(d=6,h=h);
        move(x=12)
            cylinder(d=6,h=h);
        move(y=18)
            cylinder(d=6,h=h);
    }
    move(x=-5.5,y=-6/2)
        rrect([5.5+1,24,h],r=1);
    move(x=6/2,y=6/2) {
        difference() {
            cube([3,3,h]);
            move(x=3,y=3)
                cylinder(d=6,h=10,center=true);
        }
    }
    //Xl320 connectoren
    move(z=h) {
        xl320Connector(h=3,extraPlay=0.1);
        move(x=12)
            xl320Connector(h=3,extraPlay=0.1);
        move(y=18)
            xl320Connector(h=3,extraPlay=0.1);
    }
}


module abductorSupport() {
    h=ABDUCTOR_H;
    
    difference() {
        union() {
            xflip()
            move(y=6)
                xl320SideConnect();
            //Side wall
            move(x=5.5-2.5+fit_clearance,y=0)
                rrect([2.5-fit_clearance,20.5+6.5,h+1.5],r=1-fit_clearance);            

            cylinder(d=11,h=2.25);
            move(x=-11/2)
                cube([11,3,h]);
            
            zrot(180)move(x=11/2,y=-6/2) {
                difference() {
                    cube([3,3,h]);
                    move(x=3,y=3)
                        cylinder(d=6,h=10,center=true);
                }
            }
            
            //Hold Support
            move(x=3-fit_clearance) {
                hull() {
                    move(y=-(5-fit_clearance)/2,x=-3+fit_clearance,z=2.5)
                        cube([3-fit_clearance,5-fit_clearance,1]);
                    move(y=-(4-fit_clearance)/2-2,x=-3+fit_clearance-2)
                        cube([3-fit_clearance+3,4-fit_clearance+2,h]);                
                }         
                hull() { //Screw connector
                    move(z=h+6)
                    yrot(-90)
                        cylinder(d=5-fit_clearance,h=3-fit_clearance);
                    move(y=-(5-fit_clearance)/2,x=-3+fit_clearance)
                        cube([3-fit_clearance,5-fit_clearance,h+1]);
                }            
            }
        }
        
        
        //Bottom Screw
        move(z=-1) {
            cylinder(d=3,h=3+1);
            move(z=3+1)
                sphere(d=3);
        }
        //Top Holder screw
        move(z=h+6)
        yrot(-90)
            cylinder(d=3,h=20,center=true);                
    } 
}

module abductorArm() {
    h=ABDUCTOR_H;    
    difference() {
        union() {
            //fillet(r=5) 
            {
                hull() { //base body
                    cylinder(d=18,h=h);
                    move(x=12-6/2,y=6)
                        cylinder(d=6,h=h);          
                }                
                hull() { //Screw connector
                    move(z=h+6)
                    yrot(-90)
                        cylinder(d=5-fit_clearance,h=3-fit_clearance);
                    move(y=-(5-fit_clearance)/2,x=-3+fit_clearance)
                        cube([3-fit_clearance,5-fit_clearance,h+1]);
                }

                hull() {
                    move(y=-(5-fit_clearance)/2,x=-3+fit_clearance,z=2.5)
                        cube([3-fit_clearance,5-fit_clearance,1]);
                    move(y=-(5-fit_clearance)/2-2,x=-3+fit_clearance-2)
                        cube([3-fit_clearance+3,5-fit_clearance+2,h]);                
                }
            }
            move(y=6)
                xl320SideConnect(h=h);
            //Side wall
            move(x=-5.5,y=6.5)
                rrect([2.5-fit_clearance,20.5,h+1.5],r=1-fit_clearance);                
        }

        //Remove hull overshot 
        move(x=9,y=-20+3,z=-10)
            rrect([20,20,20],r=2.5);
        
        //XL320 Arm screws TODO its a copy
        up(h-1.5)
        zrot(45) zring(n=4)
        move(y=6) {
            cylinder(d=4+fit_clearance,h=5);
            cylinder(d=2+moving_clearance,h=20,center=true);
        }
        //---         
        move(z=h+6)
        yrot(-90)
            cylinder(d=3,h=20,center=true);        
    }
}

module abductorAsm() {
    %yrot(90)
    move(z=-12-3)zrot(180)
        xl320();
    %move(x=ABDUCTOR_H)
        move(x=12,y=-24,z=9)
        move(z=-12-3)zrot(180)xl320();
    
    zflip() yrot(90)zrot(180) 
        abductorArm();
    
    move(x=24+ABDUCTOR_H*2)xflip()yrot(90)zrot(180) {
        abductorSupport();
        move(z=6+ABDUCTOR_H,x=6)
            yrot(-90) abductorPin();
    }        
}