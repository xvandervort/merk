a = []
f = File.open "first_birthday.png", "r"
while !f.eof
  p f.read(1024)
exit 
end
#
#f.each_byte do |b|
 #p b
#end
