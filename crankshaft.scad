$fa=1;
$fs=0.8;

module crankshaft(num_stacks=1, staggered=false, cycle_percent=0) {
    piston();
}

PISTON_ROTATING_ELEMENT_RADIUS = 1;

PISTON_HEAD_RADIUS = 5;
PISTON_HEAD_HEIGHT = 5;
PISTON_HEAD_THICKNESS = 1;
PISTON_HEAD_ORING_TOP_OFFSET = 1.5;
PISTON_HEAD_ORING_RADIUS = 0.25;
PISTON_HEAD_HINGE_RADIUS = PISTON_ROTATING_ELEMENT_RADIUS;
PISTON_HEAD_HINGE_BOTTOM_OFFSET = 1.5;

PISTON_SHAFT_HOLE_DIST = 20;
PISTON_SHAFT_HOLE_RADIUS = PISTON_ROTATING_ELEMENT_RADIUS;
PISTON_SHAFT_WIDTH = 3;
PISTON_SHAFT_THICKNESS = 1;

module piston(swing_degree=0) {
    pshd = PISTON_SHAFT_HOLE_DIST;
    phhbo = PISTON_HEAD_HINGE_BOTTOM_OFFSET;
    
    piston_z_offset = PISTON_SHAFT_HOLE_DIST / 2;
    shaft_rotation = swing_degree;
    rotation_offset = pshd / 2;
    pistion_head_z_offset = pshd / 2 - phhbo;

    translate([0,0,-piston_z_offset]) {
        rotate_offset([0,shaft_rotation,0], [0,0,rotation_offset])
            piston_shaft();
        
        translate([0,0,pistion_head_z_offset])
            piston_head();
    }
}

module rotate_offset(degrees,offset) {
    offset_inv = [offset[0] * -1, offset[1] * -1, offset[2] * -1];
    
    translate(offset)
        rotate(degrees)
        translate(offset_inv)
        children(0);
} 

module piston_head() {
    piston_radius = PISTON_HEAD_RADIUS;
    piston_height = PISTON_HEAD_HEIGHT;
    
    difference() {
        cylinder(h=piston_height, r=piston_radius);
        piston_head_cavity();
        piston_head_oring_slot();
    }
    piston_head_hinge();
}

module piston_head_oring_slot() {
    oring_height = PISTON_HEAD_ORING_RADIUS * 2;
    oring_cut_offset = PISTON_HEAD_RADIUS + 0.001;
    oring_depth = PISTON_HEAD_RADIUS - PISTON_HEAD_ORING_RADIUS;
    oring_z_offset = PISTON_HEAD_HEIGHT - PISTON_HEAD_ORING_TOP_OFFSET;
    
    translate([0,0,oring_z_offset])
        ring(oring_height,oring_cut_offset,oring_depth, center=true);
}

module ring(h,outer_radius,inner_radius,center=false) {
    inner_cavity_offset = 0.0001;
    inner_cavity_h = h + (inner_cavity_offset * 2);
    
    difference() {
        cylinder(h=h,r=outer_radius, center=center);
        translate([0,0,-inner_cavity_offset])
            cylinder(h=inner_cavity_h,r=inner_radius,center=center);
    }
}

module piston_head_cavity() {
    phh = PISTON_HEAD_HEIGHT;
    pht = PISTON_HEAD_THICKNESS;
    phr = PISTON_HEAD_RADIUS;
    
    piston_cavity_z_offset = -0.01;
    
    piston_cavity_h = phh - pht + piston_cavity_z_offset;
    piston_cavity_r = phr - pht;
  
    translate([0,0,piston_cavity_z_offset])
        cylinder(h=piston_cavity_h, r=piston_cavity_r);
}

module piston_head_hinge() {
    phr = PISTON_HEAD_RADIUS;
    pht = PISTON_HEAD_THICKNESS;
    
    hinge_length = (phr * 2) - (pht / 2);
    hinge_r = PISTON_HEAD_HINGE_RADIUS;
    hinge_z_offset = PISTON_HEAD_HINGE_BOTTOM_OFFSET;
  
    translate([0,0,hinge_z_offset])
        rotate([90,0,0])
        cylinder(hinge_length, r=hinge_r, center=true);
}

module piston_shaft() {
    difference() {
        piston_shaft_body();
        piston_shaft_drill_holes();
    }
}

module piston_shaft_body() {
    piston_shaft_dimensions = [
        PISTON_SHAFT_WIDTH,
        PISTON_SHAFT_THICKNESS,
        PISTON_SHAFT_HOLE_DIST
    ];
    
    cube(piston_shaft_dimensions, center=true);
            
    round_end_offest = PISTON_SHAFT_HOLE_DIST / 2;
    round_end_radius = PISTON_SHAFT_WIDTH / 2;
    round_end_thickness = PISTON_SHAFT_THICKNESS;
    
    translate([0,0,round_end_offest])
        rotate([90,0,0])
        cylinder(h=round_end_thickness, r=round_end_radius, center=true);
    translate([0,0,-round_end_offest])
        rotate([90,0,0])
        cylinder(h=round_end_thickness, r=round_end_radius, center=true);
}

module piston_shaft_drill_holes() {
    peg_radius = PISTON_SHAFT_HOLE_RADIUS;
    peg_height = PISTON_SHAFT_THICKNESS + 1;
    peg_offset = PISTON_SHAFT_HOLE_DIST / 2;
    
    translate([0,0,peg_offset])
        rotate([90,0,0])
        cylinder(h=peg_height, r=peg_radius, center=true);
    translate([0,0,-peg_offset])
        rotate([90,0,0])
        cylinder(h=peg_height, r=peg_radius, center=true);
}


crankshaft();
