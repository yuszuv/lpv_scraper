require "dry/files"

RSpec.describe LPVScraper::ArticlesRepo do
  subject(:repo) { described_class.new }

  let(:attrs) do
    { name: "foobar",
      gnu: "gnar" }
  end

  let(:articles_file) { SPEC_ROOT.join("fixtures/articles.csv") }
  let(:original_articles_file) { SPEC_ROOT.join("fixtures/articles.csv.orig") }

  before(:each) do
    fs = Dry::Files.new
    fs.cp(original_articles_file, articles_file)
  end

  after(:each) do
    fs = Dry::Files.new
    fs.cp(original_articles_file, articles_file)
  end

  describe "#create" do
    let(:result) { repo.create(**attrs) }

    it "persists to the articles' file" do
      expect { result }.to change {
        `cat #{articles_file} | wc -l`.to_i
      }.by(1)
    end
  end
end
