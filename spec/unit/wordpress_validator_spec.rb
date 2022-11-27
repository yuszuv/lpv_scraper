RSpec.describe LPVScraper::Wordpress::Validator do
  let(:valid_input) do
    { :author=>"Jakob Schenk",
      :content=> "<div class=\"ce_text block\">foobar</div>",
      :excerpt=> "<p>Auch in diesem Jahr</p>",
      :title=>"5. Landwirtschaftstag 2022",
      :published_at=>"2022-10-21T10:38:00+02:00",
      :slug=>"5-landwirtschaftstag-2022",
      :attachment_urls=>"",
      :image_urls=>"https://www.example.com/image.JPG||https://www.example.com/other_image.png" }
  end

  let(:result) { subject.(input) }

  context "with valid input" do
    let(:input) { valid_input }

    it "successfully validates" do
      expect(result.errors).to be_empty
      expect(result).to be_success
    end
  end

  context "with missing title" do
    let(:input) { valid_input.merge(title: "") }

    it "fails" do
      expect(result.errors.to_h).to include(:title)
    end
  end

  context "with missing excerpt" do
    let(:input) { valid_input.merge(excerpt: nil) }

    it "successfully validates" do
      expect(result.errors).to be_empty
      expect(result).to be_success
    end
  end

  context "with missing author" do
    let(:input) { valid_input.merge(author: "") }

    it "fails" do
      expect(result.errors.to_h).to include(:author)
    end
  end

  describe "content validation" do
    context "with invalid html" do
      let(:input) { valid_input.merge(content: "<div>foo") }

      it "fails" do
        expect(result.errors.to_h).to include(:content)
      end
    end

    context "with plain text" do
      let(:input) { valid_input.merge(content: "foo bar foo") }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end
  end

  describe "date validation" do
    context "with date some random string" do
      let(:input) { valid_input.merge(published_at: "aldfjakd12!") }

      it "fails" do
        expect(result.errors.to_h).to include(:published_at)
      end
    end
  end

  describe "attachment_urls validation" do
    let(:url) { "https://www.example.com/foo.png" }

    context "with no data" do
      let(:input) { valid_input.merge(attachment_urls: "") }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end

    context "with one url" do
      let(:input) { valid_input.merge(attachment_urls: url) }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end

    context "with two url concatenated with '||'" do
      let(:input) { valid_input.merge(attachment_urls: "#{url}||#{url}") }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end

    context "with two url concatenated with '>>'" do
      let(:input) { valid_input.merge(attachment_urls: "#{url}>>#{url}") }

      it "fails" do
        expect(result.errors.to_h).to include(:attachment_urls)
      end
    end

    context "with something concatenated with '||'" do
      let(:url) { "foobar" }
      let(:input) { valid_input.merge(attachment_urls: "#{url}||#{url}") }

      it "fails" do
        expect(result.errors.to_h).to include(:attachment_urls)
      end
    end
  end

  describe "image_urls validation" do
    let(:url) { "https://www.example.com/foo.png" }

    context "with no data" do
      let(:input) { valid_input.merge(image_urls: "") }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end

    context "with one url" do
      let(:input) { valid_input.merge(image_urls: url) }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end

    context "with two url concatenated with '||'" do
      let(:input) { valid_input.merge(image_urls: "#{url}||#{url}") }

      it "successfully validates" do
        expect(result.errors).to be_empty
        expect(result).to be_success
      end
    end

    context "with two url concatenated with '>>'" do
      let(:input) { valid_input.merge(image_urls: "#{url}>>#{url}") }

      it "fails" do
        expect(result.errors.to_h).to include(:image_urls)
      end
    end

    context "with something concatenated with '||'" do
      let(:url) { "foobar" }
      let(:input) { valid_input.merge(image_urls: "#{url}||#{url}") }

      it "fails" do
        expect(result.errors.to_h).to include(:image_urls)
      end
    end
  end

  describe "content validation" do

  end
end
