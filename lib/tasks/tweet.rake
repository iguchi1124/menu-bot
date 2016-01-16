require_relative '../twitter_client'
require 'yaml'

desc 'Tweet'
task 'tweet' do
  keys = YAML.load_file(File.expand_path('secrets.yml'))
  client = TwitterClient.new(keys)
  image = File.open('tmp/kondate.png')
  client.update_with_media "【寮生へお知らせ】\n今週のの献立です。\nこの投稿は自動投稿です。", image
end
