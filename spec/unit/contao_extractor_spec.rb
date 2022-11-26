RSpec.describe LPVScraper::ContaoExtractor, type: :webmock do
  let(:url) { URI("https://lpv-prignitz-ruppin.de/nachrichten/landwirtschaft-und-naturschutz.html") }

  let(:result) { subject.(url) }

  it "turns a string into a nokogiri document" do
    expect(result).to be_a Nokogiri::HTML5::Document
  end
end
