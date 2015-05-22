module Store2
  RSpec.describe File do
    subject(:store) { File.new("test.yml") }
    subject(:other_store) { File.new("test_other.yml") }

    it "behaves like a value object" do
      expect(store).to eq(File.new("test.yml"))
      expect(store).not_to eq(File.new("test_other.yml"))
      expect(store).not_to eq(nil)
      expect(store).not_to eq(Object)
      expect(store).not_to eq(Object.new)
    end

    describe "#build" do
      it "builds root scoped store" do
        expect(store.build).to eq(Scoped.new(store, []))
      end
    end

    describe "#scoped" do
      it "builds scoped store with passed keys" do
        expect(store.scoped("users", "72AC97F03A")).to eq(
          Scoped.new(store, ["users", "72AC97F03A"])
        )
      end
    end
  end
end
