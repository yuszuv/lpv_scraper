require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each, type: :webmock) do
    stubbed_response = File.open(SPEC_ROOT.join("fixtures/archive.html")).read
    stub_request(:get, "https://lpv-prignitz-ruppin.de/nachrichten/landwirtschaft-und-naturschutz.html").
      to_return(status: 200, body: stubbed_response, headers: {})
  end
end
