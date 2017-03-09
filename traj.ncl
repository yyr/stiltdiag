; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March  8 2017

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

begin
  fname = "data/PARTICLE.DAT"

  nh = 96                       ;no of hours
  np = 100                      ;no of particles
  inter = 2                     ;out put frequncy (should be per hour)

  nlines = nh * np * inter
  epsize = nh * inter                   ; each particle size

  fil = asciiread(fname,-1, "float")
  init_data = fil(0:2)
  data = onedtond(fil(3:), (/nlines, 16/))

  lat = new(epsize, float)
  lon = new(epsize, float)
  parht = new(epsize, float)
  foot = new(epsize, float)

  wks = gsn_open_wks("pdf","traj")

  res                      = True
  res@gsnDraw              = False
  res@gsnFrame             = False
  res@gsnMaximize = True

  res@mpOutlineOn          = True
  res@mpLimitMode = "Corners"
  res@mpLeftCornerLatF      = 0
  res@mpRightCornerLatF     = 30
  res@mpLeftCornerLonF      = 60
  res@mpRightCornerLonF     = 100

  res@tiMainString    = "Trajectories"  ; title
  ; res@gsnCenterString = "markers every 4th time step"   ; center string

  map = gsn_csm_map(wks,res)

  pres                 = True
  pres@gsLineColor     = "yellow"
  pres@gsLineThicknessF = 0.5                ; line thickness
  traj = (/1,10,53,67,80/)          ; choose which trajectories to plot
  colors= (/"red","blue","dark green","grey","magenta"/) ; line color

  mres  = True                               ; marker resources
  first = True                               ; start of traj resources

  dum  = new(1,graphic)

  c = 0
  do parts = 0 , np - 1, 1    ; doc
    do it = parts, nlines - 1, 100    ; doc
      lat(it/100) = data(it,2)
      lon(it/100) = data(it,3)
      parht(it/100) = data(it,4)
      foot(it/100) = data(it,6)
    end do

    if ( any(traj .eq. parts )) then
      pres@gsLineColor     = colors(c)
      add_traj(wks,map,lon, lat, pres)      ; draw the traj
      c = c+1
    end if
  end do
  draw(map)
  frame(wks)
end
