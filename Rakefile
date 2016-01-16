Dir[File.expand_path('lib/tasks') << '/*.rake'].each { |file| load file }

desc 'Auto crawl and tweet'
task bot: ['clobber', 'crawl', 'convert', 'tweet']
