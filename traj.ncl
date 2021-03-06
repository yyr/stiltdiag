; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March  8 2017

load "./stiltdiag.ncl"

begin
  fname = "particle.nc"
  fh = addfile(fname, "r")

  origin = fh->ORIGIN
  data = fh->PARTICLE_DATA

  dims = dimsizes(data)
  np = dims(1)

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
  res@tiMainString    = "Trajectories"

  map = gsn_csm_map(wks,res)

  pres                 = True
  pres@gsLineThicknessF = 0.5                ; line thickness
  traj = (/1,10,53,67,80/)          ; choose which trajectories to plot

;  cmap = RGBtoCmap("mpl_ylorrd.rgb")
  rgb = asciiread("mpl_ylorrd.rgb", -1, "float")
  cmap = onedtond (rgb, (/dimsizes(rgb)/3, 3/))  ; back to triplets
  cnLevels=fspan(0,6000,121)

  do it = 0 , np - 1, 1    ; doc
    lat = data(:,it,2)
    lon = data(:,it,3)
    zagl = data(:,it,4)
    zsfc = data(:,it,5)
    foot = data(:,it,6)

    zagl = zagl + zsfc
    do j=0,dimsizes(zagl)-2
      pres@gsLineColor= GetFillColor(cnLevels,cmap,avg( (/zagl(j),zagl(j+1)/)))
      gsn_polyline(wks, map, (/lon(j),lon(j+1)/), (/lat(j),lat(j+1)/), pres)
    end do
  end do

  marker = True
  marker@gsMarkerIndex  = 16
  marker@gsMarkerSizeF  = 4.0         ; marker size
  marker@gsMarkerColor  = "black"     ; marker color
  gsn_polymarker(wks,map,origin(1), origin(0),marker) ; draw start of traj

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
  res_lb@lbTitleString = "Height from the Mean Sea Level"
  res_lb@lbTitleFontHeightF = 0.015

  gsn_labelbar_ndc(wks, dimsizes(cnLevels)+1, flt2string(cnLevels), .30, .30, res_lb)

  draw(map)
  frame(wks)
end
