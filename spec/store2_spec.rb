RSpec.describe Store2 do
  describe ".open" do
    it "opens a file" do
      expect(Store2.open("test.yml")).to eq(Store2::File.new("test.yml"))
    end
  end
end
