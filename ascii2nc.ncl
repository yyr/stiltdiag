; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March  8 2017

begin
  fname = "PARTICLE.DAT"
  out = "particle.nc"
  system("rm " + out )

  o = addfile(out, "c")
  fil = asciiread(fname,-1, "float")
  init_data = fil(0:2)
  data = onedtond(fil(3:), (/2400,16/))

  lat = new(24, float)
  lon = new(24, float)
  parht = new(24, float)
  foot = new(24, float)

  do it = 0, 2399, 100    ; doc
    lat(it/100) = data(it,2)
    lon(it/100) = data(it,3)
    parht(it/100) = data(it,4)
    foot(it/100) = data(it,6)
  end do

  xyres             = True
  xyres@gsnDraw     = False
  xyres@gsnFrame    = False
  xyres@gsnMaximize = True

  wks = gsn_open_wks("x11","draw_order")

  res                      = True

  res@gsnDraw              = False
  res@gsnFrame             = False

  res@gsnMaximize          = True
  res@gsnAddCyclic          = False   ; Don't add longitude cyclic pt.

  res@mpOutlineOn          = True

  res@cnLineDrawOrder      = "PostDraw"  ; These resources can be one of
  res@cnLinesOn = False
  res@mpLimitMode = "Corners"
  res@mpLeftCornerLatF      = 10
  res@mpRightCornerLatF     = 20
  res@mpLeftCornerLonF      = 70
  res@mpRightCornerLonF     = 80

  plot = gsn_csm_map(wks,res)

  gres                 = True
  gres@gsFillColor     = "yellow"
  dum = gsn_add_polygon(wks,plot,lon,lat,gres)

  draw(plot)
  frame(wks)
end
