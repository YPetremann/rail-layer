game.simulation.camera_position = {1, 0.75}
local surface = game.surfaces[1]

surface.create_entities_from_blueprint_string
{
  string = "0eNqtlG2PwiAMx79LX2+LTHEPX+ViFpw4iQwMMD1j9t2vbEZ35y6HySW8obQ/Smn/N9jKjp+MUA7KG4haKwvlxw2saBST3qZYy6EEw4SEPgKhdvwTStJvIuDKCSf4GDFsrpXq2i036BBNI+M7L4KTthijlUd7DiUJjeAKZUzShOIFO2F4PXqs+uiFmz641iG5Obh4SO2VvMruXPI3dfmg1sw0Or6wBl1nmEWSZ3TC5YptJa+kboR1orbV5SBw3+qzUA2UeyYtj0AbgReykbRIUurreEaTNkhSnZQzOa3CX1qEv5QGUykJp67DqctwahZOpeHU/HtnSnZF6wxy/W9f7Xg7zojYTSZKdbXkzMT7jo+TNbqhl6om3eHDnjv8E+tYfUS2f9rsCfn1JO03Pa7XmhThlX5jqsgiHPtGC5P3taX4KS0k9QJmna6PFYqeGu137fPWQRP2RnthzH0Sdyt2z3ao5dID/J9hGk8RjeDMjR2uoOu0WBUFzfIsy9aLvv8CMpvKxw==",
  position = {-4, 0}
}
surface.create_entity{name = "entity-ghost", inner_name="straight-rail", position = {5, 0}, direction=defines.direction.east}
surface.create_entity{name = "entity-ghost", inner_name="straight-rail", position = {7, 0}, direction=defines.direction.east}
surface.create_entity{name = "entity-ghost", inner_name="rail-signal", position = {6, 2}, direction=defines.direction.west}