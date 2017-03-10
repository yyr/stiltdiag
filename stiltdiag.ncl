; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, March 10 2017

load "$nsc/generic.ncl"
load "./config.ncl"

;_____________________________________________________________________________
; procedure: add_traj
; Doc:
;_____________________________________________________________________________
undef("add_traj")
procedure add_traj(wks, map, lats, lons, pres)
local lats, lons, pres

begin
  str = unique_string("traj")
  map@$str$ = gsn_add_polyline(wks,map,lats,lons,pres)
  return
end
