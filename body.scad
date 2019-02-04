use <./lib/bcad.scad>
use <./vitamins.scad>
use <./utils.scad>
include <./config.scad>

bodyAsm();

module bodyAsmEnd() {
    zrot(-90)xrot(90)
        verticalPlate();

    yflip_copy()
    move(z=4.25,y=8.5)
    move(x=54/2)
    xrot(57.5)
        latticeSide();
        
    move(x=54/2,z=14.5)
        latticeTop();

    move(x=54)
    yrot(90)zrot(90)
    	endPlate();    
}

module bodyAsm() {
    move(z=16.75)
    zrot(180) latticeCenter();
    
    xflip_copy() {
        yflip_copy()
        move(y=-33+9-12,x=-24/2)
            %zrot(90) xrot(-90)zrot(90-5) xl320();        
    }
    
    xflip_copy()
    move(x=24+2)
        bodyAsmEnd();
}


module bodySnapPoints() {
    //Lattice Top
    xflip_copy()
        move(x=21/2,y=14.5)
            children();
    //Lattice Side
    xflip_copy()
    move(x=2.65,y=-4.85)
    zrot(57.5) move(x=22/2)
    xflip_copy()        
    move(x=22/2)
        children();
}

module perpendicularAxisFixationHoles() {
        xflip_copy()
        move(y=8,x=-8)
            children();
        move(y=-9)
            children();
}


//Overrides bcad.scad's sparse_strut
module sparse_strut(length=100, width=50, thick=5, strut=5, r=3) {
	dang = atan((width-2*strut)/(length-2*strut));
	dlen = (width-2*strut)/sin(dang);
    
    fillet(r=r)  {
        //We cant use xyflip_copy here or grid_of
        move(x=-length/2+strut/2)
            cube([strut,width,thick],center=true);
        move(x=length/2-strut/2)
            cube([strut,width,thick],center=true);
        move(y=-width/2+strut/2)
            cube([length,strut,thick],center=true);
        move(y=width/2-strut/2)
            cube([length,strut,thick],center=true);
        
        zrot(-dang)
            cube([dlen,strut,thick],center=true);
        zrot(dang)
            cube([dlen,strut,thick],center=true);
    }
}




module latticeSide() {
    sparse_strut(length=54,width=25,strut=2,r=2,thick=2);
    xyflip_copy()
    move(x=2/2+54/2,y=22/2,z=-fit_clearance)
        cube([2,3-fit_clearance*2,2-fit_clearance*2],center=true);
}

module latticeTop() {  
    difference() {
        union() {
            fillet(r=3) {
                union() {
                    sparse_strut(length=54,width=26,strut=2,r=2,thick=2);
                    xyflip_copy()
                    move(x=2/2+54/2,y=21/2)
                        cube([2,3,2],center=true);
                }
                move(x=-54/2+1+2)
                    cylinder(d=6,h=2,center=true);
            }
            yflip_copy()
            move(y=26/2-4,z=-2/2)
                rrect([54/2,4,2],r=2);
        }
        
        //tool holes
        yflip_copy()
        move(x=54/4,y=26/2-4/2)
        xspread(n=4,spacing=6)
            cylinder(d=2+fit_clearance,h=10,center=true);
        
        move(x=-54/2+3)
        	cylinder(d=3,h=10,center=true);
    }
}

module latticeCenter() {  
    //zrot(180) move(x=40,z=1)move(x=-54-24-2+ PiSizeX/2) zrot(180) PiZeroBody();
            
    difference() {
        union() {
            //Base
            fillet(r=3) {
                union() {
                    sparse_strut(length=24*2,width=40,strut=2,thick=2);    
                    xflip_copy()
                    move(x=24+4/2-1) {
                        fillet(r=3) {
                            rrect([4+2,40,2],r=2,center=true);
                            move(x=4)
                                cylinder(d=6,h=2,center=true);
                        }
                    }
                }

                //PiZero mounting support
                move(x=7.5-PiSizeX/2+PiHoleEdge,y=PiSizeY/2-PiHoleEdge)
                    cylinder(d=6,h=2,center=true);   
                move(x=7.5-PiSizeX/2+PiHoleEdge,y=-PiSizeY/2+PiHoleEdge)
                    cylinder(d=6,h=2,center=true);   

                hull() {
                    move(x=24+4/2-2+4,y=-PiSizeY/2+PiHoleEdge)
                        cylinder(d=6,h=2,center=true);
                    move(x=7.5+ PiSizeX/2-PiHoleEdge,y=-PiSizeY/2+PiHoleEdge)
                        cylinder(d=6,h=2,center=true);
                }                
                hull() {
                    move(y=PiSizeY/2-PiHoleEdge) {
                        move(x=24+4/2-2+4)
                            cylinder(d=6,h=2,center=true);
                        move(x=7.5+ PiSizeX/2-PiHoleEdge)
                            cylinder(d=6,h=2,center=true);
                    }
                }
            }            
        }
        //Snap cuts
        xyflip_copy()
        move(x=24+1,y=12.5)
            cube([2+fit_clearance,11+fit_clearance*2,10],center=true);
        //end cylinders
        xflip_copy()
        move(x=24+4/2-1+4)
            cylinder(d=3,h=10,center=true);
        
        //PiHoles
        move(x=PI_OFFSET) {
            xflip_copy() yflip_copy()
            move(x=PiSizeX/2-PiHoleEdge,y=PiSizeY/2-PiHoleEdge)
                cylinder(d=3,h=10,center=true);
        }
    }    
}

module verticalPlate() {
    difference() {
        union() {
            xflip_copy()
            move(x=-33+9-12,z=2) {
                zrot(+5)
                move(x=33-9)               
                yflip_copy() move(y=6)
                    xl320Connector(h=3.75, extraPlay=0.2);
            }
            hull() {
                move(x=-36/2,y=14)
                    cube([36,4,2]);    
                xflip_copy()
                move(x=-33+9-12) {
                    zrot(+5)
                    move(x=33-9,y=6) {
                        cylinder(d=6,h=2);
                    }
                }
            }
            hull() {
                xflip_copy() {
                    move(x=-33+9-12) {
                        zrot(+5)
                        move(x=33-9)
                        yspread(spacing=6,n=3) {
                            cylinder(d=6,h=2);
                        }
                    }    
                    
                    move(x=-3,y=-7.75)
                        cylinder(d=2,h=2);
                }
            }
        }
        
        //Lattice snap points cut out
        bodySnapPoints()
            cube([3+fit_clearance*2,2+fit_clearance*2,10],center=true);

        //Top snap cut
        move(y=15.5+20/2)
            cube([14,20,10],center=true);
        
        move(y=15.5-2-5/2)
            rrect([14+1,5,10],r=2,center=true);
        
        //Center weight saving
        hull() {
            xflip_copy() {
                move(x=-8,y=10.25)
                    cylinder(d=2.5,h=10,center=true);
                move(x=-5,y=1)
                    cylinder(d=2.5,h=10,center=true);
                move(y=0)
                    cylinder(d=2.5,h=10,center=true);
            }
        }
        
        //Center holes for xl320
        xflip_copy()
        move(x=-33+9-12) {
            zrot(+5)
            move(x=33-9)
                cylinder(d=4,h=10,center=true);
        }          
    }
}



module endPlateBase() {    
    difference() { 
        union() {
            hull() {
                bodySnapPoints()
                    move(x=2,y=-0.5)cylinder(d=5,h=2);
                move(y=-10)
                    cylinder(d=5,h=2);
            }           
            //Bearing wings
            hull() {
                xflip_copy() {
                    move(x=15.5,y=16)
                        cylinder(d=3,h=2);           
                    move(x=36)
                        cylinder(d=10,h=2);
                }
                move(y=-11)
                    cylinder(d=3,h=2);           
            }
            //Bearing holes
            xflip_copy()
            move(x=36) {
                cylinder(d=10,h=BEARING_H+fit_clearance);
                //up(BEARING_H+fit_clearance)
                //    cylinder(d1=10,d2=6.5,h=1.5);
            }
        }
        bodySnapPoints()
                cube([3+fit_clearance*2,2+fit_clearance*2,10],center=true);        
        //Save weight
        hull() {
            xflip_copy()
            move(x=2,y=1)
                cylinder(d=5,h=10,center=true);
            xflip_copy()
            move(y=9,x=8.5)
                cylinder(d=3,h=30,center=true);            
            xflip_copy()
            move(y=11,x=1)
                cylinder(d=3,h=30,center=true);
        }
    }
}

module endPlate(support=false) {
    difference() {
        union() {
            endPlateBase();            
            move(y=8,x=8)
                cylinder(d=7.5,h=2);
            move(y=8,x=-8)
                cylinder(d=7.5,h=2);
        }
        //extra holes
        xflip_copy()
        move(y=14.5,x=-6)
            cylinder(d=2.8,h=10,center=true);
        
        //Perpendicular_axis_fixation holes
        perpendicularAxisFixationHoles()
            cylinder(d=2.8,h=10,center=true);
        
        //Bearing holder wings
        xflip_copy()
        hull() {
           move(x=30,y=4)
                cylinder(d=3,h=10,center=true);
           move(x=28.5,y=-1.5)
                cylinder(d=3,h=10,center=true);
            move(x=18,y=10.5)
                cylinder(d=3,h=10,center=true);
            move(x=8,y=-6)
                cylinder(d=3,h=10,center=true);
        }
        //Save weight side
        xflip_copy()
        move(x=12.25,y=3)    zrot(58.5)
            rrect([16,4,10],r=2,center=true);
        
        //Bearing cut
        xflip_copy() move(x=36,z=3+fit_clearance+1) {
            bearingCut(extraPlay=-0.1);
            //#cylinder(d=5.7+moving_clearance,h=100,center=true);
        }
               
        //top
        move(y=20/2+15.5+0.5)
            rrect([8,20,10],r=2,center=true);        
    }
    if(support) {
        xflip_copy() move(x=36)
            cylinder(d=5,h=BEARING_H+fit_clearance-layer_height);
    }
}