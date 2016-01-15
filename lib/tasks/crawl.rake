require_relative '../crawler/crawler'

desc 'Crawl http://www.kochi-ct.ac.jp'
task 'crawl' do
  crawler = Crawler.new
  pdf_file_urls = crawler.get_pdf_urls
  recent_menu_url = crawler.find_recent_menu(pdf_file_urls)
  crawler.download_file!(recent_menu_url)
end
