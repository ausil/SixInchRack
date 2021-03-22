include<../sixinch_library.scad>


  ///////////////////////////////
 // Orange Pi PC2             //
///////////////////////////////

print_frontplate_sml = true;
print_handle_sml     = false;
print_cabinet_sml    = false;
print_lid            = false;
print_rear           = false;

depth = 90;
units = 2;
    
if(print_frontplate_sml){ // Frontplate //
    square_hole        = [[64,3 ,14 , 3], [83 ,6, 13, 8]];
    round_hole         = [[58 ,8.5, 2]];
    round_peg          = [];   
    screw_side_front   = [];
    screw_top          = [36];
    screw_bottom_front = [36];
    frontplate(units,square_hole,round_hole,round_peg,screw_side_front,screw_top,screw_bottom_front);

}

if(print_handle_sml){ // Handle // 
    lay_flat_for_print = false;   
    handle(units,lay_flat_for_print);
}

if(print_cabinet_sml){ // Cabinet //  
    w=80;
    h=84;
    screw_bottom_front = [36];
    screw_side_front   = [];
    round_peg          = [[w,h,6,2.8,5],
                          [w-50,h,6,2.8,5],
                          [w-50,h-79,6,2.8,5],
                          [w,h-79,6,2.8,5]];
    cabinet(depth,units,screw_bottom_front,round_peg,screw_side_front);
}

if(print_lid){ // Lid // 
    screw_front = [36];//mm
    screw_back  = [36];//mm
    lid(depth,units,screw_front,screw_back);        
}

if(print_rear){  // Back plate //    
    square_hole  = [[32 ,6, 15, 16] , [50 ,6, 16.5, 14] , [68.5,6,7.5,15] ];
    round_hole   = [[6,5,6],[6,1,6], [24,3.5,3.5],[24,1.2,3.5]  ,[30,3.5,3.5],[30,1.2,3.5]];
    screw_top    = [36];//mm
    screw_bottom = [36];//mm
    screw_side   = [];
    back_plate(units,depth,screw_top,screw_bottom,screw_side,square_hole,round_hole);
}  
