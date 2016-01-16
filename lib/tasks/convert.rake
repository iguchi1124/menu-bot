require 'grim'

desc 'convert pdf to image'
task 'convert' do
  pdf = Grim.reap('tmp/kondate.pdf')
  pdf[0].save('tmp/kondate.png', colorspace: 'CMYK', quality: 100)
end
