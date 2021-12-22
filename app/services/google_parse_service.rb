# frozen_string_literal: true

class GoogleParseService

  def initialize(html:)
    @html = html
    @document = Nokogiri::HTML(html)
  end

  def result
    {
      ads_top_count: ads_top_count,
      ads_page_count: ads_page_count,
      non_ads_count: non_ads_count,
      total_links_count: total_links_count
    }
  end

  private

  attr_reader :html, :document

  # Number of AdWords advertisers in the top position.
  def ads_top_count
    document.css('#tads > div').count
  end

  # Total number of AdWords advertisers on the page.
  def ads_page_count
    ads_top_count + document.css('.pla-unit-container').count
  end

  # URLs of the AdWords advertisers in the top position.
  def ads_top_urls
    document.css("#tads > div a[data-ved]").map { |a| a['href'] }
  end

  # Number of the non-AdWords results on the page.
  def non_ads_count
    document.css('a[data-ved] > h3').count
  end

  # URLs of the non-AdWords results on the page.
  def non_ads_urls
    document.css("a[data-ved] > h3").map { |h3| h3.parent['href'] }
  end

  # Total number of links (all of them) on the page.
  def total_links_count
    document.css('a').count
  end
end
