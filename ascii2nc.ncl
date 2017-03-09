; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March  8 2017

begin
  fname = "data/PARTICLE.DAT"
  out = "particle.nc"
  system("rm " + out )

  nh = 96                       ;no of hours
  np = 100                      ;no of particles
  inter = 2                     ;out put frequncy (should be per hour)

  nlines = nh * np * inter
  epsize = nh * inter                   ; each particle size

  o = addfile(out, "c")
  fil = asciiread(fname,-1, "float")
  init_data = fil(0:2)
  data = onedtond(fil(3:), (/nlines, 16/))

  lat = new(epsize, float)
  lon = new(epsize, float)
  zagl = new(epsize, float)
  foot = new(epsize, float)
  pres = new(epsize, float)

  do parts = 0 , np - 1, 1    ; doc
    do it = parts, nlines - 1, 100    ; doc
      lat(it/100) = data(it,2)
      lon(it/100) = data(it,3)
      zagl(it/100) = data(it,4)
      foot(it/100) = data(it,6)
      foot(it/100) = data(it,15)
    end do
  end do
end
