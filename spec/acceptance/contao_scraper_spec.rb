RSpec.describe LPVScraper::ContaoScraper do
  subject(:app) do
    described_class.new(
      contao_spider: contao_spider,
      wordpress_mapper: wordpress_mapper,
      fetch_html: fetch_html,
      validate: validate,
      repo: repo,
    )
  end

  let(:args) { {} }

  let(:html) { double("html") }
  let(:data) { double("data") }
  let(:result) { double("result") }
  let(:result_data) { double("result data") }
  let(:tuple) { double("tuple") }
  let(:news_urls) { 10.times.map { double("url") } }

  let(:fetch_html) { instance_double("LPVScraper::ContaoExtractor") }
  let(:contao_spider) { instance_double("LPVScraper::ContaoSpider") }
  let(:wordpress_mapper) { instance_double("LPVScraper::WordpressMapper") }
  let(:validate) { instance_double("LPVScraper::WordpressValidator") }
  let(:repo) { instance_double("LPVScraper::ArticlesRepo") }

  context "with everything set up correctly" do

    it "runs successfully" do
      expect(fetch_html).to receive(:call).at_least(:once).and_return(html)
      expect(fetch_html).to receive(:to_proc).at_least(:once).and_return(->(x) { fetch_html.call(x) })

      expect(contao_spider).to receive(:call).with(html).and_return(news_urls)

      expect(wordpress_mapper).to receive(:to_proc).and_return(->(x) { wordpress_mapper.call(x) })
      expect(wordpress_mapper).to receive(:call).exactly(news_urls.length).times.and_return(data)

      expect(validate).to receive(:to_proc).and_return(->(x) { validate.call(x) })
      expect(validate).to receive(:call).exactly(news_urls.length).times.and_return(result)

      allow(result).to receive(:success?).and_return(true)
      allow(result).to receive(:to_h).and_return(result_data)

      allow(repo).to receive(:create).with(result_data).and_return(tuple)

      # expect(app.()).to eq [tuple]
      app.(**args)
    end
  end

  context "with invalid data"

  context "with wordpress mapper returning wrong data"

  context "with the file system storage failing"
end
