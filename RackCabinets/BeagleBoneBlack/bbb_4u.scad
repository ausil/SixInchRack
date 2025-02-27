
$fn = 50*1;

//Constants, do not change !
sixinch   = 155*1;       // cm = 6"  
width     = 155-20-20;   // 11.5cm between rails
unit      = (44.5/19)*6; // 1U
gauge     = 3*1;
gauge_box = 2*1;

Part = "e"; // [a:All, b:FrontPlate, c:Cabinet, d:Lid, e:BackPlate, f:Handles]
Units = 2;
Depth = 115;

//Cabinet screws in mm. They can be changed a little
screw_head        = 7.4; 
screw_head_height = 2.2;  
screw_dia         = 3;   
screw_hole        = 2.6; 
screw_length      = 15;
nut_4mm           = 8.1; 
slip              = 0.35;


// Measurements taken from https://github.com/rmd6502/openscad/blob/master/beagleboneblack.scad
inch = 25.4;
//holeR = 0.125/2 * inch;
holeR = 1.4;
module bbb_peg(center) {
    translate(center) {
        difference() {
        cylinder(r=holeR*2, h=7);
        cylinder(r=holeR, h=10);
        }
    }
}

if(Part=="c") {
    translate([-(unit/2+3) - 120  + (0.575 * inch) + gauge_box+1, -20 - 30, gauge_box]) {
        mirror([1,0,0]) {
        bbb_peg([-(0.575 * inch), -(0.125 * inch), 0]);
        bbb_peg([-(0.575 * inch), -(2.025 * inch), 0]);
        bbb_peg([-(3.175 * inch), -(0.250 * inch), 0]);
        bbb_peg([-(3.175 * inch), -(1.900 * inch), 0]);
        }
    }
    go();
} else if(Part=="e") {
    difference() {
        go();
        // translate to box's origin
        translate([-130, -20, gauge_box]) {
            // usb port
            translate([0, - 32 - 13, 0]) {
                cube([100, 13, 8]);
            }
            // 5V barrel connector
            translate([0, - 69.5 - 9.5, 7+2]) {
                cube([100, 9.5, 9.5]);
            }
            // Ethernet
            translate([0, - 45 - 17,1.5+.8 +7]) {
                cube([21.0,17.0,13.5]);
            }
        }
    }
} else {
    go();
}

module go(){
    rotate([90,0,-90]){
        if(Part=="a"){
            frontplate(Units,[],[],[],[Units/2],[45],[45]);
            cabinet(Depth,Units,[45],[],[Units/2]);
            lid(Depth,Units,[45],[45]);        
            back_plate(Units,Depth,[45],[45],[Units/2],[],[]);
            handle(Units,false);   
        }else if(Part=="b"){
            frontplate(Units,[],[],[],[Units/2],[45],[45]);
        }else if(Part=="c"){
            cabinet(Depth,Units,[45],[],[Units/2]);
        }else if(Part=="d"){
            lid(Depth,Units,[45],[45]); 
        }else if(Part=="e"){
            back_plate(Units,Depth,[45],[45],[Units/2],[],[]);
        }else if(Part=="f"){
            handle(Units,true);
        }
    }
}




  /////////////////////////////
 // Raspberry Cabinet       //
/////////////////////////////

print_frontplate_sml = false;
print_handle_sml     = false;
print_cabinet_sml    = false;
print_lid            = false;
print_rear           = false;

if(print_frontplate_sml){ // Frontplate //
    square_hole        = [[60 ,3, 28, 4]];
    round_hole         = [[105 ,5, 3.4],[110 ,5, 3.4]];
    round_peg          = [];   
    screw_side_front   = [];
    screw_top          = [36];
    screw_bottom_front = [36];
    units              = 2; 
    frontplate(units,square_hole,round_hole,round_peg,screw_side_front,screw_top,screw_bottom_front);

}

if(print_handle_sml){ // Handle // 
    units              = 2;
    lay_flat_for_print = false;   
    handle(units,lay_flat_for_print);
}

if(print_cabinet_sml){ // Cabinet //  
    screw_bottom_front = [36];
    screw_side_front   = [];
    round_peg          = [[40,35,6,screw_hole,6],
                          [65,90,6,screw_hole,6],
                          [32,90,6,0,6],
                          [65,35,6,0,6]];
    depth              = 98;
    units              = 2;
    cabinet(depth,units,screw_bottom_front,round_peg,screw_side_front);
}

if(print_lid){ // Lid // 
    depth = 98;
    units = 2;
    screw_front = [36];//mm
    screw_back  = [36];//mm
    lid(98,2,screw_front,screw_back);        
}

if(print_rear){  // Back plate //    
    square_hole  = [[17+5 ,5, 18, 15] , [38+5 ,5, 17, 17] , [70+8,5,10,3] ];
    round_hole   = [];
    screw_top    = [36];//mm
    screw_bottom = [36];//mm
    screw_side   = [];
    depth        = 98;
    units        = 2;
    back_plate(units,depth,screw_top,screw_bottom,screw_side,square_hole,round_hole);
}  
 
  
  
  
  


module chimney() {    
for(i=[0:8:80]){
    echo(i);
    translate([20 + (width-80)/2  +i,-1,20]){
        minkowski(){
            cube([0.01,200,30]);    
            sphere(d=2,h=1);        
        }
    }
}
}





  /////////////////////////////
 // Cabinet for measurements //
/////////////////////////////
/*
screw_bottom_front   = [36,62];//mm
difference(){
    union(){
        box(sixinch,2);
        for(i=[0:11]){
            translate([-0.5+20+gauge_box+i*10,0,gauge]){cube([1,3,sixinch]);}
        }
        for(i=[1:15]){
            translate([20,0,gauge-0.5+i*10]){cube([width,3,1]);}
        }
        translate([24,0,12]){rotate([-90,0,0]){linear_extrude(10){text("1",size=7);}}}
       
    }    
    translate([0,18,0]){cube([400,30,400],center=true);}
}
*/



module fan(sz,vent,hole,grid,head){
    difference(){
        intersection(){
            translate([sz/2,sz/2,0]){cylinder(d=vent,h=10);}    
            translate([-hole/2,-hole/2,0]){cube([sz+hole,sz+hole,10]);}
        }        
        for(i=[-grid*8:grid:grid*8]){        
            translate([sz/2+i,sz/2,5]){
                rotate([0,0,45]){
                    cube([2,100,12],center=true);        
                }
            }
            translate([sz/2+i,sz/2,5]){
                rotate([0,0,-45]){
                    cube([2,100,12],center=true);        
                }
            }
        }        
    }
    translate([0,0,0])  {cylinder(d=hole,h=10); cylinder(d1=head,d2=0,h=head/1.5);  }
    translate([sz,0,0]) {cylinder(d=hole,h=10); cylinder(d1=head,d2=0,h=head/1.5);  }
    translate([sz,sz,0]){cylinder(d=hole,h=10); cylinder(d1=head,d2=0,h=head/1.5);  }
    translate([0,sz,0]) {cylinder(d=hole,h=10); cylinder(d1=head,d2=0,h=head/1.5);  }        
}







//trap(11);

// Nut-less Trap
module trap(u){
    difference(){
        union(){
            translate([-2.4,0,4]){
                cube([4.8,unit*u,1.5]);
            }    
            translate([-2.4,unit*u,0]){
                rotate([90,0,0]){
                    linear_extrude(unit*u){
                        polygon(points=[[0,0],[4.8,0],[7,4],[-2.2,4]]);
                    }
                }
            }
        }
        
        
    
    
    for(i=[1:u]){
        translate([0,unit*i-unit/2,-1]){
            cylinder(d=3.8,h=10);
        }                       
    }
}
}






//0: open
//1: grid
//2: chimney
//rack_end(2);

// Rack
module rack_end(type){
    //REDEFINING SIXINCH WITH AN EXTRA mm
    sixinch = sixinch+1;
    difference(){
    union(){
    translate([1.25,1.25,1.25]){
        minkowski(){
            w = sixinch-2.5;            
                cube([w, w, gauge-2.5]);                        
            sphere(r=1.25);
        }
    }
    }
    translate([20,20,-1]){ cube([sixinch-40,sixinch-40,gauge+2]);}
   
    translate([10,10,-0.1])                { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
    translate([sixinch-10,10,-0.1])        { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
    translate([10,sixinch-10,-0.1])        { cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}
    translate([sixinch-10,sixinch-10,-0.1]){ cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);}  
  
    rotate([-90,0,0]){
    chimney();
    }
    
    }  


    if(type==1){
    intersection(){
        union(){
    sz=8;
    grid = 15;
    for(i=[-grid*8:12:grid*8]){        
            translate([sz/2+i+70,sz/2+78,gauge/2]){
                rotate([0,0,45]){
                    cube([2,sixinch*1.5,gauge],center=true);        
                }
            }
            translate([sz/2+i+70,sz/2+82,gauge/2]){
                rotate([0,0,-45]){
                    cube([2,sixinch*1.5,gauge],center=true);        
                }
            }
        }
    }
        translate([15,15,-1]){cube([125,125,10]);}
    
    }
    }
    
}

//tophandle();


module tophandle(){
    difference(){
        union(){
            rotate([0,45,0]){
                extrusion(4,false,false,false);
            }
            translate([sixinch,20,0]){
                rotate([0,45,180]){
                    extrusion(4,false,false,false);
                }
            }
        }    
        wedge();            
        translate([90,90,10]){
           cube([200,200,20],center=true);
        }
       
        translate([10,10,0]){handlescrew();}
        translate([sixinch-10,10,0]){handlescrew();}
        
    }
    intersection(){
        translate([0,0,-27.4]){
            extrusion(11,false,false,false);
        }
        wedge();        
    }
    
    
    
}

module handlescrew(){
    translate([0,0,-39]){cylinder(d=5,h=40); }
    translate([0,0,-4]){cylinder(d1=10,d2=6,h=3.5);}
    translate([0,0,-34]){cylinder(d=10,h=30);}
}


module wedge(){
    translate([sixinch/2,-10,15]){
        rotate([0,45+45/2,0]){
            cube([80,80,30]);
        }
        translate([0,80,0]){
            rotate([0,45+45/2,180]){
                cube([80,80,30]);
            }
        }
        translate([-20,0,-100]){
            cube([40,80,100]);
        }
    }
}



//extrusion(4,true,true,true);
//translate([0,22,0]){extrusion(4,true,true,true);}
//translate([0,44,0]){extrusion(4,true,true,true);}
//translate([0,66,0]){extrusion(4,true,true,true);}

module extrusion(u,center,front,side){
    len=unit*u;
   difference(){
    translate([0,2,2]){
        minkowski(){
            cube([len,16,16]);
            sphere(d=4);
        }
    } 

    translate([-5,10,1.99]){
        rotate([0,90,0]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
    }
    translate([-5,10,18.01]){
        rotate([0,-90,180]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
    }
    
    translate([-5,18.01,10]){
        rotate([90,0,90]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
    }
    
     translate([-5,1.99,10]){
        rotate([-90,0,-90]){linear_extrude(len+10){polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);}}
    }
    
    if(center){
        translate([-5,10,10]){
            rotate([0,90,0]){
                cylinder(d=4.6,h=len+10);
            }
        }
    } 
    
    //holes
    if(front){
        for(i=[0:30]){
             translate([unit/2+i*unit,10,-5]){ cylinder(d=3.8,h=30);}
        }
    }    
    if(side){
        for(i=[0:30]){
            translate([unit/2+i*unit,25,10]){ rotate([90,0,0]){cylinder(d=3.8,h=30);}}
        }
    }

    //length cutoff
    translate([-2,0,0]){cube([4,60,60],center=true);}
    translate([len+2,0,0]){cube([4,60,60],center=true);}    
    }
}











 
 

 
     
 module back_plate(u,dp,screw_top,screw_bottom,screw_side,square_hole,round_hole){
    

     
     difference(){
        union(){
            translate([20+gauge_box+slip,gauge_box+slip,gauge+dp-gauge_box]){
                cube([width-2*gauge_box-2*slip, u*unit-2*gauge_box-2*slip, gauge_box]);
            }
        }
     
     //Square holes
        for(i=[0:len(square_hole)-1]){
            x = square_hole[i][0];
            y = square_hole[i][1];
            w = square_hole[i][2];
            h = square_hole[i][3];            
            translate([x+20+gauge_box,y+gauge_box,dp-1]){cube([w,h,gauge+2]);}        
        } 
    
    //Round holes
    if(len(round_hole)>0){
        for(i=[0:len(round_hole)-1]){
            x = round_hole[i][0];
            y = round_hole[i][1];
            dia = round_hole[i][2];
            translate([20+gauge_box+x,gauge_box+y,dp-4]){  cylinder(d=dia,h=10); }
        }
    }
        
    
    //Screw holes
    if(len(screw_top)>0){
        for(i=[0:len(screw_top)-1]){
            p = screw_top[i];
            translate([p,unit*u-gauge_box-4,gauge+dp+0.1]){rotate([0,180,0]){screw();}}
            translate([sixinch-p,unit*u-gauge_box-4,gauge+dp+0.1]){rotate([0,180,0]){screw();}} 
        }
    }
    if(len(screw_bottom)>0){
        for(i=[0:len(screw_bottom)-1]){
            p = screw_bottom[i]; 
            translate([p,gauge_box+4     ,gauge+dp+0.1]){rotate([0,180,0]){screw();}}
            translate([sixinch-p,    gauge_box+4    ,gauge+dp+0.1]){rotate([0,180,0]){screw();}} 
        }
    }
    
    if(len(screw_side)>0){
        for(i=[0:len(screw_side)-1]){
            p = screw_side[i];  
            translate([sixinch-20-6,    unit*p    ,gauge+dp+0.1]){rotate([0,180,0]){screw();}} 
            translate([20+6,    unit*p    ,gauge+dp+0.1]){rotate([0,180,0]){screw();}}   
        }
    }
}
}

 
 


module peg(x,y,od,id,he){
    translate([x,y,0]){
        rotate([-90,0,0]){
            difference(){
                cylinder(r=od/2,h=he);
                translate([0,0,-0.5]){cylinder(r=id/2,h=he+1);}
            }        
        }
    }
}



module screwtrap(){  
    difference(){
        translate([0,0,5]){
            intersection(){
                scale([1,1,0.7]){
                    sphere(r=8);     
                }   
                translate([0,-0.001,-10]){  cube([20,20,20]);}
            }
        }  
        translate([2,4,5]){
            rotate([90,90,90]){
               translate([0,0,-10]){ cylinder(r=screw_dia/2,h=20,$fn=100);}
            }
        }    
    }
}





module nuttrap(){
    difference(){
        linear_extrude(10){
            polygon(points=[[0,0],[8,0],[2,8],[0,8]]);
        }
        translate([2,4,5]){
            rotate([90,90,90]){
                cylinder(r=nut_4mm/2,h=20,$fn=6);
            }
        }
        translate([2,4,5]){
            rotate([90,90,90]){
               translate([0,0,-10]){ cylinder(r=screw_dia/2,h=20,$fn=100);}
            }
        }
    }
}








module cabinet (dp,u,screw_bottom_front,round_peg,screw_side_front){
    difference(){
        box(dp,u,screw_bottom_front,round_peg,screw_side_front);
            translate([0,7,44]){
                // HDMI Raspberry slot
                //   cube([30,14,25]);
            }
            
               translate([20,unit/2+3,sixinch-40]){ cylinder(d=gauge_box,h=41);}
               translate([20,unit/2+0,sixinch-40]){ cylinder(d=gauge_box,h=41);}
               translate([20,unit/2-3,sixinch-40]){ cylinder(d=gauge_box,h=41);}
            
               translate([20+width,unit/2+3,sixinch-40]){ cylinder(d=gauge_box,h=41);}
               translate([20+width,unit/2+0,sixinch-40]){ cylinder(d=gauge_box,h=41);}
               translate([20+width,unit/2-3,sixinch-40]){ cylinder(d=gauge_box,h=41);}
               
              
        }
       
    }





module box(dp,u,screw_bottom_front,round_peg,screw_side_front){
    difference(){
        translate([20,0,gauge]){
            difference(){
                cube([115,u*unit,dp]);
                translate([gauge_box,gauge_box,-1]){ cube([115-gauge_box*2,u*unit,dp+2]);}

                //FAN    
                translate([width+0.1,15,35]){
                    //rotate([0,-90,0]){ fan(50,57,3.5,15,6.5);}
                }         
            }            
        }
        //CHIMNEY
        chimney(); 
    }
    
    //Screw mounts on the bottom plate
    for(i=[0:len(screw_bottom_front)-1]){
        p = screw_bottom_front[i];
        translate([p+5,gauge_box,gauge]){rotate([0,-90,0]){screwtrap();}}
        translate([sixinch-p+5,gauge_box,gauge]){rotate([0,-90,0]){screwtrap();}}        
        translate([p-5,gauge_box,gauge+dp-gauge_box]){rotate([0,90,0]){screwtrap();}}
        translate([sixinch-p-5,gauge_box,gauge+dp-gauge_box]){rotate([0,90,0]){screwtrap();}}
   }
    
   //Screw mounts on the side of cabinet
   if(len(screw_side_front)>0){
        for(i=[0:len(screw_side_front)-1]){
            p = screw_side_front[i]*unit;
                translate([20+gauge_box,p-5,gauge]){rotate([0,-90,-90]){screwtrap();}}
                translate([sixinch-20-gauge_box,p+5,gauge]){rotate([0,-90,90]){screwtrap();}}    
                translate([20+gauge_box,p+5,gauge+dp-gauge_box]){rotate([0,90,-90]){screwtrap();}}
                translate([sixinch-20-gauge_box,p-5,gauge+dp-gauge_box]){rotate([0,90,90]){screwtrap();}}    
        }
    }
    
    //Screw mounts for lid. Two on each side, three if dp>90
    translate([20+gauge_box,unit*u-gauge_box,gauge+10]){rotate([0,0,-90]){screwtrap();}}
    translate([20+gauge_box,unit*u-gauge_box,gauge+dp-10-10]){rotate([0,0,-90]){screwtrap();}}            
    translate([sixinch-20-gauge_box,unit*u-gauge_box,gauge+10+10]){rotate([180,0,-90]){screwtrap();}}
    translate([sixinch-20-gauge_box,unit*u-gauge_box,gauge+dp-10-10+10]){rotate([180,0,-90]){screwtrap();}}
    if(dp>90){
        translate([sixinch-20-gauge_box,unit*u-gauge_box,gauge+dp/2-5+10]){rotate([180,0,-90]){screwtrap();}}
        translate([20+gauge_box,unit*u-gauge_box,gauge+dp/2-5]){rotate([0,0,-90]){screwtrap();}}
    }
        
    //Lid rest bar 
    translate([20+gauge_box,unit*u-3-gauge_box,gauge]){
        linear_extrude(dp-gauge_box){polygon (points=[[0,0],[3,3],[0,3]]);}
    }
    translate([sixinch-20-gauge_box,unit*u-3-gauge_box,gauge]){
        linear_extrude(dp-gauge_box){polygon (points=[[0,0],[-3,3],[0,3]]);}
    }
        
    // Back/front rest bar
    translate([0,0,dp+gauge-2-gauge_box]){
        difference(){
            translate([20,0,0]){  cube([width,unit*u-gauge_box,2]);  }
            translate([20+gauge_box+2,gauge_box+2,-1]){  cube([width-2*gauge_box-4,unit*u,4]);  }        
        }
    }
              
    //PEGS Relative to inside corner
    translate([20+gauge_box,0,gauge]){ 
        if(len(round_peg)>0){
            for(i=[0:len(round_peg)-1]){
                x = round_peg[i][0];
                y = round_peg[i][1];
                od = round_peg[i][2];
                id = round_peg[i][3];  
                he = round_peg[i][4];      
                translate([x,0,y]){peg(0,0,od,id,he); }
             }        
        }
    }    
}


module lid(dp,u,screw_front,screw_back){    

    difference(){
    union(){ 
        if(len(screw_front)>0){
            for(i=[0:len(screw_front)-1]){                                
                p = screw_front[i];                
                translate([p-5,unit*u-gauge_box,gauge]){rotate([0,-90,180]){screwtrap();}}
                translate([sixinch-p-5,unit*u-gauge_box,gauge]){rotate([0,-90,180]){screwtrap();}}
            }
        }        
        if(len(screw_back)>0){
            for(i=[0:len(screw_back)-1]){                                
                p = screw_back[i];                                
                translate([p+5,unit*u-gauge_box,gauge+dp-gauge_box]){rotate([0,90,180]){screwtrap();}}
                translate([sixinch-p+5,unit*u-gauge_box,gauge+dp-gauge_box]){rotate([0,90,180]){screwtrap();}} 
            }
        }
        
        
        
        
        //lid
        translate([20+gauge_box+slip,u*unit-gauge_box,gauge]){
            cube([115-gauge_box*2-slip*2,gauge_box,dp]);
        }    
        //back rest
        translate([sixinch/2-40,u*unit-gauge_box-2,gauge+dp-2-gauge_box]){
            cube([80,2,2]);
        }
    }        

    //Negative
    translate([20+gauge_box+4,unit*u+0.01  ,gauge+10+5]){rotate([90,0,0]){screw();}}
    translate([20+gauge_box+4,unit*u+0.01  ,gauge+dp-10-10+5]){rotate([90,0,0]){screw();}}    
    translate([sixinch-20-gauge_box-4,unit*u+0.01   ,gauge+10+10-5]){rotate([90,0,0]){screw();}}
    translate([sixinch-20-gauge_box-4,unit*u +0.01  ,gauge+dp-10-10+10-5]){rotate([90,0,0]){screw();}}
    if(dp>90){
        translate([sixinch-20-gauge_box-4,unit*u+0.01   ,gauge+dp/2-5+10-5]){rotate([90,0,0]){screw();}}    
        translate([20+gauge_box+4,unit*u+0.01   ,gauge+dp/2-5+5]){rotate([90,0,0]){screw();}}
    }
     chimney();

    
}        
}




module screw(){
    cylinder(r1=screw_head/2, r2=screw_dia/2, h=screw_head_height);
    cylinder(r=screw_dia/2, h=40);    
    translate([0,0,-0.99]){cylinder(r=screw_head/2, h=1);}    
}


module frontholes(u,screw_top,screw_bottom_front,screw_side_front){
    if(len(screw_bottom_front)>0){ 
    for(i=[0:len(screw_bottom_front)-1]){
        p = screw_bottom_front[i];
        translate([p,gauge_box+4,-0.01]){screw();}
        translate([sixinch-p,gauge_box+4,-0.01]){screw();}
    } 
    }    
    if(len(screw_side_front)>0){   
        for(i=[0:len(screw_side_front)-1]){
            p = screw_side_front[i]*unit;
            translate([20+gauge_box+4,p,-0.01]){screw();}
            translate([sixinch-20-gauge_box-4,p,-0.01]){screw();}    
        } 
    }   
    if(len(screw_top)>0){   
    for(i=[0:len(screw_top)-1]){
        p = screw_top[i];
        translate([p,unit*u-gauge_box-4,-0.01]){screw();}
        translate([sixinch-p,unit*u-gauge_box-4,-0.01]){screw();}    
    }
    }
}  
    




module handle(u,print){
    
    if(print){
        translate([16,-u*unit,8]){rotate([0,90,0]){handle1(u);}}
        translate([0,-u*unit,8]){rotate([0,90,0]){handle1(u);}}
    }else{
        translate([22,2,0]){rotate([0,180,0]){handle1(u);}}
        translate([sixinch-14,2,0]){rotate([0,180,0]){handle1(u);}}        
    }        
}

module handle1(u){
    difference(){
        handle2(8,u*unit-4,10,3);
        translate([-1,5,-1]){handle2(10,u*unit-10-4,6,3);}
    
        translate([4,2.5,-1]){          cylinder(r=screw_hole/2,h=9);}
        translate([4,u*unit-4-2.5,-1]){ cylinder(r=screw_hole/2,h=9);}
    }
}


module handle2(w,h,d,ra){          
    translate([0,ra,d-ra]){
        rotate([0,90,0]){
            cylinder(r=ra,h=w);
        }
    }
    translate([0,h-ra,d-ra]){
        rotate([0,90,0]){
            cylinder(r=ra,h=w);
        }
    }        
    translate([0,ra,0]){
        cube([w,h-ra-ra,d]);
    }
    cube([w,h,d-ra]);    
}











module insideprofile(l){
    difference(){
        union(){
            translate([7.6,10,0]){cube([4.8,10,l]);}
            translate([0,7.6,0]){cube([20,4.8,l]);}  
            
            translate([6.5,10-2.1,0]){cube([7   ,10,l]);}
            translate([2.1,6.5,0]){cube([15.8,7   ,l]);}  
        }
        translate([4,4,-1]){
            cube([12,12,l+2]);
        }
    } 
    translate([20,20,0]){
        rotate([0,-90,0]){
            linear_extrude(20){
                polygon (points=[[0,0],[l,0],[0,l]]);
            }
        }
    }    
}



module rightbottomplate(t){
    difference(){
        bottomplate(t);
        translate([-1,-1,-1]){
            cube([(sixinch+20)/2+1,sixinch+20+2,t+2]);
        }
    }
}

module leftbottomplate(t){
    difference(){
        bottomplate(t);
        translate([(sixinch+20)/2,-1,-1]){
            cube([(sixinch+20)/2+1,sixinch+20+2,t+2]);
        }
       # translate([10,10,-1]){cylinder(r=2.5,h=base+2);}
        translate([10,sixinch+20-10,-1]){cylinder(r=2.5,h=base+2);}
    
        
        translate([(sixinch+20)/2-20,-1,2.1]){cube([40,sixinch+20+2,2]);}
        
        }
    
    translate([0,0,base]){insideprofile(10);}
    rotate([0,0,180]){translate([-20,-sixinch-20,base]){insideprofile(10);}}
    
    
    
}


module bottomplate(t){
translate([1,1,0]){
    minkowski(){
        cube([sixinch+20-2,sixinch+20-2,t-1]);
        cylinder(r=1,h=1);
    }
}
}




module frontplate(u,square_hole,round_hole,round_peg,screw_side_front,screw_top,screw_bottom_front){

    difference(){
        baseplate(u);
        
                   
        
        //Square holes
        if(len(square_hole)>0){
        for(i=[0:len(square_hole)-1]){
            x = square_hole[i][0];
            y = square_hole[i][1];
            w = square_hole[i][2];
            h = square_hole[i][3];            
            translate([x,y,-1]){cube([w,h,gauge+2]);}        
        } 
        }
        
       //Round holes
        if(len(round_hole)>0){
        for(i=[0:len(round_hole)-1]){
            x = round_hole[i][0];
            y = round_hole[i][1];
            d = round_hole[i][2];                       
            translate([x,y,-1]){cylinder(r=d/2,gauge+1);}        
        }   
    }

        //Cabinet holes
        frontholes(u,screw_top,screw_bottom_front,screw_side_front);
        
        //Handle holes
        translate([18,4.5,gauge-0.25]){rotate([180,0,0]){screw();}}
        translate([18,u*unit-4.5,gauge-0.25]){rotate([180,0,0]){screw();}}        
        translate([sixinch-18,4.5,gauge-0.25]){rotate([180,0,0]){screw();}}
        translate([sixinch-18,u*unit-4.5,gauge-0.25]){rotate([180,0,0]){screw();}}
    } 

    //chassis support
    /*
    translate([20+gauge_box,gauge_box,gauge]){
        difference(){
            cube([115-gauge_box*2,u*unit-2*gauge_box,3]);
            translate([gauge_box,gauge_box,-1]){ cube([115-gauge_box*4,u*unit-gauge_box*4,5]);}
        }
    } */



     //Handle base
    /*
        translate([14,0,0]){
            cube([8,u*unit,gauge/2]);
        }
        translate([sixinch-22,0,0]){
            cube([8,u*unit,gauge/2]);
        }
    */

    //Support pegs
    if(len(round_peg)>0){
        for(i=[0:len(round_peg)-1]){
            x = round_peg[i][0];
            y = round_peg[i][1];
            od = round_peg[i][2];
            id = round_peg[i][3];  
            he = round_peg[i][4];  
            translate([x,y,gauge]){
                difference(){
                 #   cylinder(r=od/2,h=he);
                 #   cylinder(r=id/2,h=he+1);
                }        
            }
    
        }
    }
    
    //cabinet support bars
    translate([0,0,gauge]){
        translate([20+width*0.25,gauge_box,0]){  cube([width*0.5,1,1]);  }
        translate([20+width*0.25,unit*u-1-gauge_box,0]){  cube([width*0.5,1,1]);  }           
    }
    
    
    
    }



 //cube([sixinch,unit*1,gauge]);

//sidepanel(4,true);

module sidepanel(u,handle){
    difference(){
        baseplate(u);
    
        if(handle){
         
              translate([(sixinch-80)/2,8,-4]) { cube([80,20,10]);}
              translate([(sixinch-80)/2,18,-4]) { cylinder(d=20,h=10);}
              translate([sixinch-(sixinch-80)/2,18,-4]) { cylinder(d=20,h=10);}
        }
    }
}


module baseplate(u,handle){
    difference(){
    union(){
        translate([1.25,1.25,1.25]){
            minkowski(){
                cube([sixinch-2.5,unit*u-2.5,gauge-2.5]);
                sphere(r=1.25);
            }
        }
    }
    //Rack mount holes
    translate([10-0.5,unit/2,-gauge/2])                 {cylinder(r=2.3,gauge*2);}
    translate([sixinch-10+0.5,unit/2,-gauge/2])         {cylinder(r=2.3,gauge*2);}
    translate([10-0.5,u*unit-(unit/2),-gauge/2])        {cylinder(r=2.3,gauge*2);}
    translate([sixinch-10+0.5,u*unit-(unit/2),-gauge/2]){cylinder(r=2.3,gauge*2);}
    if(u>=5){
        translate([10-0.5,(u*unit)/2,-gauge/2])         {cylinder(r=2.3,gauge*2);}
        translate([sixinch-10+0.5,(u*unit)/2,-gauge/2]) {cylinder(r=2.3,gauge*2);}
    }  
}    
}



















