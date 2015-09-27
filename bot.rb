require 'open-uri'
require 'nokogiri'
require 'grim'
require 'twitter'
require 'yaml'

Dir.mkdir('tmp') unless Dir.exists?('tmp')

keys = YAML.load_file('secrets.yml')
root_url = 'http://www.kochi-ct.ac.jp'
url = 'http://www.kochi-ct.ac.jp/index.php/sessei/sesseitop'
pdf_file_path = 'tmp/kondate.pdf'
file_urls = []
file_url = ''

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = keys['consumer_key']
  config.consumer_secret     = keys['consumer_secret']
  config.access_token        = keys['access_token']
  config.access_token_secret = keys['access_token_secret']
end

charset = nil

html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
doc.css('#seikatsu').xpath('//tbody//tr//td//ul//li//a').css('a').each do |a|
  if (url = a[:href]) =~ /kondate/
    file_urls << "#{root_url + url}"
  end
end

file_urls.each do |url|
  file_version = url.gsub(/[^0-9]/,'').to_i
  version = ('15' + ('%02d' % Time.now.month) + ('%02d' % Time.now.day)).to_i
  file_url = url if file_version - version < 7
end

puts file_url

open(pdf_file_path, 'wb') do |output|
  open(file_url) do |data|
    output.write(data.read)
  end
end

pdf = Grim.reap(pdf_file_path)
pdf[0].save('tmp/kondate.png', colorspace: 'CMYK', quality: 100)

client.update_with_media("【寮生へお知らせ】\n今週の献立です。\nこの投稿は自動投稿です。", File.new('tmp/kondate.png'))
