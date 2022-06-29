/*
 License: GPL v3, or any later version

 This file is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3, or (at your option)
 any later version.

 This file is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
//---------------------------------------------------------------
/*
HVAC Knob
Date: 2022-06-20
# NOTES
* The units are in milimeters, unless commented otherwise.
* when the knob is printed on an ender 3 d


*/
$fa=.01; // "disable" the angular minumum.
print_resolution=1;
resolution=print_resolution * ($preview?20:1);
$fs=resolution/4; // Convert to ni-quest Resolution 

// primative Head 
    knobHeight = 15;
    majorDiameter = 25;
    minorDiameter = 7;
// gripCuts
    cutAngle = 12;// This value is in degrees
    cornerRadius = 5;
// neck
    neckHeight = 10;
    stemOD = 11;
    stemID = 6.5;
    DcutHeight = 16.5;
    DcutOffset = 2;
// Finishing Touches
    smooth_rad=2;

knob();

module knob(){
    difference(){
        smooth_head();
        difference(){
            translate([0, 0, -neckHeight])cylinder(DcutHeight,d= stemID);
            translate([DcutOffset, -(stemOD / 2), -neckHeight])cube([stemOD, stemOD, DcutHeight]);
        }
    }
    
    neck(neckHeight, stemOD, stemID);
    
    module smooth_head()
        if($preview)
            head();
        else minkowski(5){
            head();
            sphere(r= smooth_rad);}
            
    module head(){
        difference(){
            primativeHead(knobHeight, majorDiameter, minorDiameter);
                gripCuts(cutAngle, cornerRadius);
                mirror([0, 1, 0])gripCuts(cutAngle, cornerRadius);
            
        }
        
        module primativeHead(knobHeight, majorDiameter, minorDiameter){
            hull(){
                cylinder(knobHeight, d= majorDiameter, $fn= 100);//Major 
                translate([majorDiameter / 2, 0, 0])
                    cylinder(knobHeight, d= minorDiameter, $fn= 100);// Minor
                }
            }
            
        module gripCuts(cutAngle, cornerRadius){
            translate([0, (majorDiameter - minorDiameter) + (cornerRadius/ 2), knobHeight])
                rotate([0,0, -cutAngle])// rotate's values are in degrees
                    minkowski(convexity= 4){
                        cube([majorDiameter* 2, majorDiameter -cornerRadius, knobHeight -cornerRadius],center= true);
                            sphere(r= cornerRadius, $fn= 75);
                    }
            }
        }
    
    module neck(neckHeight, stemOD, stemID){
        // this will likely be fine but will need some fine tuning. the stemID will like be wrong.
        difference(){
            translate([0, 0, -neckHeight])cylinder(neckHeight,d= stemOD);
                difference(){
                    translate([0, 0, -neckHeight])cylinder(DcutHeight,d= stemID);
                        translate([DcutOffset, -(stemOD / 2), -neckHeight])cube([stemOD, stemOD, DcutHeight]);
                    }
        }
                
    }
}
