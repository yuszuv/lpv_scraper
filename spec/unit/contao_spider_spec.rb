require 'nokogiri'

RSpec.describe LPVScraper::ContaoSpider do
  let(:input) { Nokogiri::HTML5(File.open(input_path).read) }
  let(:input_path) { SPEC_ROOT.join("fixtures/archive.html") }

  let(:result) { subject.(input) }

  it "yields the extracted news article urls" do
    expect { |b| result.each(&b) }.to yield_successive_args(*%w(
        https://lpv-prignitz-ruppin.de/nachrichten/landwirtschaft-und-naturschutz.html
        https://lpv-prignitz-ruppin.de/nachrichten/auswertung-gartenwettbewerb-2021.html
        https://lpv-prignitz-ruppin.de/nachrichten/58.html
        https://lpv-prignitz-ruppin.de/nachrichten/3-feldtag-am-kalksee.html
        https://lpv-prignitz-ruppin.de/nachrichten/gr%C3%BCnlandpflege-auf-feuchten-standorten.html
        https://lpv-prignitz-ruppin.de/nachrichten/verl%C3%A4ngerung-der-bewerbungsfrist-f%C3%BCr-garten-der-vielfalt.html
        https://lpv-prignitz-ruppin.de/nachrichten/54.html
        https://lpv-prignitz-ruppin.de/nachrichten/praxiserhebungen-zum-lupinenanbau.html
        https://lpv-prignitz-ruppin.de/nachrichten/52.html
        https://lpv-prignitz-ruppin.de/nachrichten/bienen-und-agroforst..html
      )
        .map{ URI(_1) }
    )
  end
end
