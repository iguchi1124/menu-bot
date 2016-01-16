require 'open-uri'
require 'nokogiri'
require 'grim'

class FileNotFoundError < StandardError
end

class Crawler

  # crawler = Crawler.new
  # pdf_file_urls = crawler.get_pdf_urls
  # recent_menu_url = crawler.find_recent_menu(pdf_file_urls)
  # crawler.download_file!(recent_menu_url)

  def root_url
    'http://www.kochi-ct.ac.jp'
  end

  def crawl_path
    '/index.php/sessei/sesseitop'
  end

  def html
    @charset = nil

    uri = URI.parse("#{root_url + crawl_path}")

    uri.open do |f|
      @charset = f.charset
      f.read
    end
  end

  def get_pdf_urls
    doc = Nokogiri::HTML.parse(html, nil, @charset)
    file_paths = []
    doc.css('#seikatsu').xpath('//tbody//tr//td//ul//li//a').css('a').each do |a|
      path = a[:href]
      file_paths << "#{root_url + path}" if a[:href] =~ /kondate/
    end
    file_paths
  end

  def find_recent_menu(paths)
    file_url = nil
    paths.each do |path|
      file_version = path.gsub(/[^0-9]/,'').to_i
      year = Time.now.year
      year_s = (year - (year / 100) * 100).to_s
      version = (year_s + ('%02d' % Time.now.month) + ('%02d' % Time.now.day)).to_i
      file_url = path if file_version - version < 7
    end
    if file_url.nil?
      raise FileNotFoundError
    else
      file_url
    end
  end

  def download_file!(url)
    file_uri = URI.parse(url)

    File.open('tmp/kondate.pdf', 'wb') do |output|
      file_uri.open do |data|
        output.write(data.read)
      end
    end
  end
end
