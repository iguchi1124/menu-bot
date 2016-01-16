Dir[File.expand_path('lib/tasks') << '/*.rake'].each { |file| load file }

desc 'all'
task bot: ['clobber', 'crawl', 'convert', 'tweet']
