require "hound/linters/base"
require "hound/linters/javascript"

describe Hound::Linter::Javascript do
  describe "#status" do
    it "delegates to base linter" do
      base_linter = instance_double("Hound::Linter::Base", status: "Enabled")
      linter = Hound::Linter::Javascript.new(base_linter)

      expect(linter.status).to eq "Enabled"
    end
  end

  describe "#config" do
    context "when config is provided" do
      it "returns a success message" do
        filepath = ".javascript-style.json"
        linter = build_linter(filepath)
        stub_file(filepath, "{}")

        expect(linter.config).to eq "Using #{filepath}"
      end
    end

    context "when config file cannot be found" do
      it "returns an error message" do
        linter = build_linter(".foo-style.yml")

        expect(linter.config).to include ".foo-style.yml does not exist"
      end
    end

    context "when config is not provided" do
      it "returns a default message" do
        linter = build_linter(nil)

        expect(linter.config).to eq "Not provided -- using default"
      end
    end

    context "when config cannot be parsed" do
      it "returns an error message" do
        filepath = ".javascript-style.json"
        stub_file(filepath, "")
        linter = build_linter(filepath)

        expect(linter.config).to include "#{filepath} is invalid JSON"
      end
    end
  end

  def build_linter(filepath)
    options = { "config_file" => filepath }.reject { |key, value| value.nil? }
    base_linter = Hound::Linter::Base.new(name: "javascript", options: options)
    Hound::Linter::Javascript.new(base_linter)
  end
end
