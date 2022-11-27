require 'nokogiri'

RSpec.describe LPVScraper::Wordpress::Mapper do
  subject(:mapper) { described_class.new }

  let(:input) { Nokogiri::HTML5(File.open(input_path)) }
  let(:result) { mapper.(input) }

  context "a simple html page" do
    let(:input_path) { SPEC_ROOT.join("fixtures/simple.html") }

    it "extracts the article content" do
      expect(result).to be_a Hash
      expect(result).to include(
        title: "Absage: Vogelstimmenexkursion",
        content: /\A<.*>\z/,
        excerpt: /\A<.{,300}>\z/,
        author: "Jakob Schenk",
        published_at: "2020-04-21T10:07:00+02:00",
        slug: "absage-vogelstimmenexkursion",
        attachment_urls: /^(?:(?<link>https?:\/\/[^|\s]+)\|\|)*\g<link>?$/,
        image_urls: /^(?:(?<link>https?:\/\/[^|\s]+)\|\|)*\g<link>?$/,
      )
    end

    it "strips the href tags"
  end

  context "a fully featured page" do
    let(:input_path) { SPEC_ROOT.join("fixtures/full.html") }

    it "extracts the article content" do
      expect(result).to be_a Hash
      expect(result).to include(
        title: "Kooperativer Agrarschutz",
        content: /\A<.*>\z/,
        excerpt: /\A(?:<.{,300}>)?\z/,
        author: "Tabea Kannenberg",
        published_at: "2022-09-09T09:09:00+02:00",
        slug: "kooperativer-agrarschutz",
        attachment_urls: /^(?:(?<link>https?:\/\/[^|\s]+)\|\|)*\g<link>$/,
        image_urls: /^(?:(?<link>https?:\/\/[^|\s]+)\|\|)*\g<link>$/,
      )
    end

    it "prefixes relative hrefs with base url" do
      content = result[:content]
      href_regexp = /(?<=href=")(?<link>\S+?)(?=")/

      expect(content.scan(href_regexp).flatten).to all(match(URI.regexp))
    end

    it "prefixes relative srcs with base url" do
      content = result[:content]
      src_regexp = /(?<=src=")(?<link>\S+?)(?=")/

      expect(content.scan(src_regexp).flatten).to all(match(URI::DEFAULT_PARSER.make_regexp))
    end
  end

  it "extracts pdf downloads"
end
