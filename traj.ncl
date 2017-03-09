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
  res@mpFillOn = False
  res@mpDataBaseVersion = "MediumRes"

  res@mpLimitMode = "Corners"
  res@mpLeftCornerLatF      = 0
  res@mpRightCornerLatF     = 30
  res@mpLeftCornerLonF      = 60
  res@mpRightCornerLonF     = 100

  res@tiMainString    = "Trajectories"  ; title
  ; res@gsnCenterString = "markers every 4th time step"   ; center string

  map = gsn_csm_map(wks,res)

  pres                 = True
  pres@gsLineThicknessF = 0.5                ; line thickness
  traj = (/1,10,53,67,80/)          ; choose which trajectories to plot

  mres  = True                               ; marker resources
  first = True                               ; start of traj resources

;  cmap = RGBtoCmap("mpl_ylorrd.rgb")
  rgb = asciiread("mpl_ylorrd.rgb", -1, "float")
  cmap = onedtond (rgb, (/dimsizes(rgb)/3, 3/))  ; back to triplets
  cnLevels=fspan(0,6000,121)

  do parts = 0 , np - 1, 1    ; doc
    do it = parts, nlines - 1, 100    ; doc
      lat(it/100) = data(it,2)
      lon(it/100) = data(it,3)
      parht(it/100) = data(it,4)
      foot(it/100) = data(it,6)
    end do

    do j=0,dimsizes(parht)-2
      pres@gsLineColor= GetFillColor(cnLevels,cmap,avg( (/parht(j),parht(j+1)/)))
      gsn_polyline(wks, map, (/lon(j),lon(j+1)/), (/lat(j),lat(j+1)/), pres)
    end do
  end do

; label bar resources
  res_lb                    = True
  res_lb@vpWidthF           = 0.50
  res_lb@vpHeightF          = 0.10
  res_lb@lbPerimOn          = False            ; Turn off perimeter.
  res_lb@lbOrientation      = "Horizontal"     ; Default is vertical.
  res_lb@lbLabelAlignment   = "InteriorEdges"  ; Default is "BoxCenters".
  res_lb@lbFillColors       = cmap(2:,:)       ; Colors for boxes.
  res_lb@lbMonoFillPattern  = True             ; Fill them all solid.
  res_lb@lbLabelFontHeightF = 0.010
  res_lb@lbLabelStride = 30
  res_lb@lbTitleString = "Height from the ground (zagl)"
  res_lb@lbTitleFontHeightF = 0.015

  gsn_labelbar_ndc(wks, dimsizes(cnLevels)+1, flt2string(cnLevels), .30, .30, res_lb)

  draw(map)
  frame(wks)
end
