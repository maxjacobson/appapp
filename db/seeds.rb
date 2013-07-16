# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#joe is created
joe = User.new
joe.name = "Joe Giralt"
joe.email = "joegiralt@gmail.com"
joe.save #update the status
# joes_dossier = Dossier.new
# joes_dossier.tagline = "I need a better tagline!"
# joe.dossiers << joes_dossier
# joe.save_with_status("submitted")

max = User.new
max.name = "Max Jacobson"
max.email = "maxjacobson@maxwhatever.com"
max.dossiers.build(:tagline => "Goofy's kid")
max.save_with_status("submitted")

alex = User.new
alex.name = "Alex Au"
alex.email = "alex@alexoo.com"
alexs_dossier = Dossier.new
alexs_dossier.tagline = "get lucky"
alex.dossiers << alexs_dossier
alex.save_with_status("submitted")

sam = User.new
sam.name = "Sam Rad"
sam.email = "sam@sammo.com"
sam.dossiers.build(tagline: "Stun me")
sam.save_with_status("submitted")

#miley is submitted
miley = User.new
miley.name = "Miley Cyrus"
miley.email = "miley@twerk.com"
miley.dossiers.build(tagline: "Just can't stop")
miley.save_with_status("submitted")

dhh = User.new
dhh.name = "DHH"
dhh.email = "dhh@icreatedrails.com"
dhh.dossiers.build(tagline: "Racecars")
dhh.save_with_status("submitted")

#alex is reviewed
alex.save_with_status("reviewed")
sam.save_with_status("reviewed")
dhh.save_with_status("reviewed")

#sam is accepted
#max is deferred
#dhh is declined
sam.save_with_status("accepted")
max.save_with_status("deferred")
dhh.save_with_status("declined")





