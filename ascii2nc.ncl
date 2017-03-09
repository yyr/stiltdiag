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
  nt = nh * inter

  o = addfile(out, "c")
  fil = asciiread(fname,-1, "float")
  init_data = fil(0:2)
  data = onedtond(fil(3:), (/nlines, 16/))


  fAtt               = True            ; assign file attributes
  fAtt@title         = "Stilt Model output PARTICLE.DAT is converted to nc"
  fAtt@source_file   =  "PARTICLE.DAT"
  fAtt@Conventions   = "None"
  fAtt@creation_date = systemfunc ("date")
  fileattdef( o, fAtt )            ; copy file attributes

  do parts = 0 , np - 1, 1    ; doc
    tim = new(epsize, float)
    lat = new(epsize, float)
    lon = new(epsize, float)
    zagl = new(epsize, float)
    foot = new(epsize, float)
    pres = new(epsize, float)

    do it = parts, nlines - 1, 100    ; doc
      tim(it/100) = data(it,1)
      lat(it/100) = data(it,2)
      lon(it/100) = data(it,3)
      zagl(it/100) = data(it,4)
      foot(it/100) = data(it,6)
      pres(it/100) = data(it,15)
    end do
    ; lat
    name = "lat" + parts
    lat!0 = "time"
    lat&time = tim
    o->$name$ = lat
    delete(lat)

    name = "lon" + parts
    lon!0 = "time"
    lon&time = tim
    o->$name$ = lon
    delete(lon)

    name = "zagl" + parts
    zagl!0 = "time"
    zagl&time = tim
    o->$name$ = zagl
    delete(zagl)

    name = "foot" + parts
    foot!0 = "time"
    foot&time = tim
    o->$name$ = foot
    delete(foot)

    name = "pres" + parts
    pres!0 = "time"
    pres&time = tim
    o->$name$ = pres
    delete(pres)
  end do
end
