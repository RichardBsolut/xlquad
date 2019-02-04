use <./lib/bcad.scad>
use <./lib/curvedPipe.scad>
use <./vitamins.scad>
use <./utils.scad>
include <./config.scad>


legAsm();


module t40p() {
    roundnes = 3;
    difference() {
        union() {
            cylinder(d=35-roundnes ,h=T40_H);
            move(z=T40_H/2)
            rotate_extrude()
            move(x=35/2-roundnes/1.5)
                scale([roundnes ,T40_H,1]) circle(d=1);            
        }
        cylinder(d=14.5+moving_clearance,h=T40_H*4,$fn=6,center=true);    
    }
}

module t40pCut() {
    hubSize = (14.5+moving_clearance) ;
    difference() {
        t40p();        
        move(y=-(hubSize*cos(30)) /2 -fit_clearance,x=-hubSize*cos(60+15),z=-100/2)
            cube([100,100,100]);        
        move(x=-100/2,y=(hubSize*cos(30)) /2,z=-100/2)
            cube([100,100,100]);              
    }
}

module femur(isSecond=false) {
    difference() {
        union() {
            fillet(r=3) {
                hull() {
                    cylinder(d=18,h=2.5); 
                    cylinder(d=16,h=3.5);                    
                }
                hull() {
                    move(x=0) {                    
                        cylinder(d=11,h=2.5);                    
                        cylinder(d=9,h=3.5);
                    }
                    if(isSecond) {
                        move(y=-11/2,x=27.75) {
                            cube([2,11,2.5]);  
                            move(y=(11-9)/2)
                                cube([2,9,3.5]);  
                        }
                        move(x=34) {                    
                            cylinder(d=7,h=2.5);                    
                            cylinder(d=5,h=3.5);
                        }
                    } else {
                        move(x=34) {                    
                            cylinder(d=11,h=2.5);                    
                            cylinder(d=9,h=3.5);
                        }
                    }
                 }
            }
        }

        //Motor Screws
        zring(n=4) move(y=6)
            cylinder(d=2+fit_clearance,h=20,center=true);

        //Bearing
        move(x=34) {
            if(!isSecond) {            
                //cylinder(d=5,h=10,center=true);
                down(4-3-fit_clearance) cylinder(d=7+fit_clearance*2,h=4);
            } else {
                move(z=-40+3)
                    cylinder(d=3,h=40);
            }
        }
        
        //tibia connect
        yflip_copy()
        move(x=24.5,y=2.5) { //TODO 24.5 must be an config
            cylinder(d=2,h=10,center=true);
            move(z=3.5-2)
                cylinder(d2=5,d1=2.2,h=2.25);
        }            
    }
    
    //Holder tabs
    move(x=24.5,z=-2/2) {
        difference() {
            hull() {
                cube([8,9,2],center=true);
                up(1+0.25)
                    cube([10.5,11,0.25],center=true);
            }
            cube([6+fit_clearance*2,15,3],center=true);
        }
    }    
    //XL320 Lower arm holder
    zrot_copies([-45,45,135,225]) 
    move(y=-6,z=-2.5) { 
        cylinder(d=4-fit_clearance*2,h=3);
        up(1.5)
            cylinder(d1=4-fit_clearance,d2=5-fit_clearance,h=1);
    }
    if(isSecond) {
        move(x=34,z=-2.25) {
            difference() {
                union() {
                    cylinder(d=7,h=2.25);
                    move(z=-1)
                        cylinder(d1=5,d2=7,h=1);
                }
                cylinder(d=3,h=20,center=true);
            }
        }
    }    
}


module femurBackBase(isSecond = false,h){
   //%import("../ocad/femur_back_2nd_4.stl");
    //Tubes   
    zflip_copy()
    move(x=24.5,z=2.6)
    curvedPipe([ [0,0,0],
                [0,h*0.3857,0],
                [-9,h*0.8571,0],
                [-9,h,0],
        ],
        3,
        [15,20,10],
        6, 3);
    //Bottom Connect plate   
    move(x=24.5,y=0.5/2) {
        hull(){
            cube([6,0.5,11],center=true);
            zflip_copy()    
            move(y=-0.5/2,z=2.6)
            xrot(-90)
                cylinder(d=6,h=1.5);
            move(y=2/2)
                cube([5,2,5],center=true);
        }
    }
    //Bearing hold right    
    move(x=34,y=9.5) {
        hull() {
            move(x=-10,z=-11/2)
                cube([10,2.5,11]);
            xrot(-90) {
                cylinder(d=11,h=2.5);
            }
        }
        if(!isSecond) {
            xrot(-90) {
                cylinder(d=11,h=3.5);
                up(3.5)
                    cylinder(d1=11,d2=10,h=0.5);
            }
        } else {
            xrot(90) {
                cylinder(d1=9,d2=7,h=1);
                cylinder(d=7,h=2);
                up(2)
                    cylinder(d1=7,d2=5,h=1);
            }
        }
    }
    
    //Bearing hold center
    move(y=h) {
        hull_around() {
            xrot(-90) cylinder(d=11,h=2.5);
            
            move(x=15.5, z=2.6)
                xrot(-90) cylinder(d=6,h=2.5);
            move(x=15.5, z=-2.6)
                xrot(-90) cylinder(d=6,h=2.5);            
        }
        xrot(-90) {
            cylinder(d=11,h=3.5);
            up(3.5)
                cylinder(d1=11,d2=10,h=0.5);
        }        
    }
}

module femurBack(isSecond=false,h=29) {
    difference() {
        femurBackBase(isSecond=isSecond,h=h);
        
        //Bearings
        move(y=h+3+fit_clearance)
            xrot(-90) bearingCut();
        if(!isSecond) {
            move(x=34,y=9.5+3+fit_clearance)
                xrot(-90) bearingCut(extraPlay=fit_clearance,od=6);
        } else {
            move(x=34,y=9.5+3+fit_clearance)
                xrot(-90) {
                   move(z=-5.75)
                     //screw("DIN 965 TX", 3, 10,play=fit_clearance,extraHead=10);
                     cylinder(d=3+fit_clearance,h=40,center=true);
                }
        }
        
        //screwholes
        zflip_copy()
        move(x=24.5,z=2.6,y=-1)
        xrot(-90)
            cylinder(d=2,h=10);
        
        //cable
        move(y=h-1,x=15.5)
            zflip_copy() up(2.6)
            xrot(-90) cylinder(d=3,h=10);
        
        //Holes
        zflip_copy()
        move(x=18,y=3,z=2.6+0.5)
        zrot(-45) xrot(-90)
            cylinder(d=2, h=10);
            
        //cable tie holes
        move(y=h-1,x=8)
            zflip_copy() up(2.6)
            xrot(-90) cylinder(d=2,h=10);
        
    }
}

module tibia() {    
    import("./vitamins/tibia3.stl");    
}

module tibia2(h=3) {
    module offsetCylinder() {
        move(x=55)
                zrot(-90-29)move(x=11)
                    cylinder(d=6,h=h);
    }
    
    difference() {        
        union() //fillet(r=3) 
        {
            //We cant use hull_around here ... its blocks fillet 
            cylinder(d=11,h=h);            
            hull() {
                move(x=55)
                    cylinder(d=11,h=h);
                offsetCylinder();
            }            
            hull() {
                move(y=2.7)
                    cylinder(d=5.75,h=h);
                offsetCylinder();
            }
        }
        //Cut bearings
        move(z=5) {
            bearingCut();
            move(x=55)
                bearingCut();
        }
    }
}

module backConnect() {
    xflip_copy()
    move(x=12) {
        xspread(n=3,spacing=6)
            yrot(180) xl320Connector();
        
        hull() {
            xflip_copy()
            move(x=6)
                cylinder(d=5,h=0.5);   
            move(z=1)
                cylinder(d1=5,d2=3,h=0.75);
        }
        cylinder(d=3,h=6);
    }
    
    hull()
    xflip_copy() {
        move(x=12) {
            move(z=1)
                cylinder(d1=5,d2=3,h=0.75);
            cylinder(d=5,h=0.5);
        }
    }   
}


module legAsm() {
    %move(x= 12,z=-24/2) zrot(180)xl320();    
    %move(x=-12,z=-24/2) zrot(180)xl320();
    
    move(z=-24)
    xrot(180) backConnect();
    
    //Right
    move(x=12,z=3.2) zrot(-45) 
        femur(isSecond=false);            

    move(x=12, z=-24-NUT_H+FEMUR_PLAY)
    zrot(-45)xrot(-90) move(y=-FEMUR_BACK_H)
        femurBack(h=FEMUR_BACK_H, isSecond=false);
    
    move(x=12,z=-1.75) {
        zrot(-45)move(x=34)
        zrot(90) move(x=-55) {
            tibia();
            zrot(10) move(x=-6,y=-2.5,z=-T40_H/2)
                t40pCut();
        }
    }
        
    //Left
    move(x=-12,z=3.2) zrot(-45-90) 
        femur(isSecond=true);            
    move(x=-12, z=-24-NUT_H+FEMUR_PLAY)
    zrot(-135)xrot(-90) move(y=-FEMUR_BACK_H)
        femurBack(h=FEMUR_BACK_H, isSecond=true);
    
    move(z=0) {
        move(x=-12) {
            zrot(-180-45)move(y=34)
            zrot(180+45-50)yrot(180)move(x=-55)tibia2();
        }
    }
}