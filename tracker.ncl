; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March  8 2017

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

  xyres             = True
  xyres@gsnDraw     = False
  xyres@gsnFrame    = False
  xyres@gsnMaximize = True

  wks = gsn_open_wks("x11","draw_order")

  res                      = True

  res@gsnDraw              = False
  res@gsnFrame             = False
  res@gsnMaximize          = True

  res@mpOutlineOn          = True
  res@mpLimitMode = "Corners"
  res@mpLeftCornerLatF      = 0
  res@mpRightCornerLatF     = 30
  res@mpLeftCornerLonF      = 60
  res@mpRightCornerLonF     = 100

  plot = gsn_csm_map(wks,res)

  gres                 = True
  gres@gsFillColor     = "yellow"

  do parts = 0 , np - 1, 1    ; doc
    do it = parts, nlines - 1, 100    ; doc
      lat(it/100) = data(it,2)
      lon(it/100) = data(it,3)
      parht(it/100) = data(it,4)
      foot(it/100) = data(it,6)
    end do
    dum = gsn_add_polygon(wks,plot,lon,lat,gres)
    print(" " + parts)
  end do

  draw(plot)
  frame(wks)
end
