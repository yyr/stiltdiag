; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March  8 2017

begin
  fname = "data/PARTICLE.DAT"
  out = "particle.nc"
  ; setfileoption("nc", "Format",  "NetCDF4")
  system("rm " + out )

  nh = 96                       ;no of hours
  np = 100                      ;no of particles
  nv = 16                       ;no of variable in the output
  inter = 2                     ;out put frequncy (should be per hour)
  varnames = (/"time", "indx", "lati", "long", "zagl", "zsfc", "foot", "samt",\
               "temp", "dswf","mlht","dens","dmas","sigw","tlgr","pres"/)

  nlines = nh * np * inter
  epsize = nh * inter                   ; each particle size
  nt = nh * inter

  o = addfile(out, "c")
  fil = asciiread(fname,-1, "float")

  origin = fil(0:2)             ; first line has three values lat lon height.
  data = onedtond(fil(3:), (/nt, np, nv/)) ;remaining all times

  data!0 = "time"
  data&time = data(:,0,0)

  data!1 = "pnumber"
  data&pnumber = ispan(0, 99, 1)

  vnames = new(16,string)
  do it = 0, nv - 1, 1
    vnames(it) = unique_string("var")
  end do
  data!2 = "variables"
  data&variables = ispan(0, 15, 1)
  ; data&variables = varnames


  fAtt               = True            ; assign file attributes
  fAtt@title         = "Stilt Model's output PARTICLE.DAT converted to nc"
  fAtt@source_file   =  "PARTICLE.DAT"
  fAtt@Conventions   = "None"
  fAtt@creation_date = systemfunc ("date")
  fileattdef( o, fAtt )

  ; write_matrix (data1(0,0:2,:), "16f7.2", False)
  ; write_matrix (data(0:2,:), "16f7.2", False)
  o->PARTICLE_DATA = data
  o->ORIGIN = origin
end
