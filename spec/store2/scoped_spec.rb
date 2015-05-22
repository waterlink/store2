module Store2
  RSpec.describe Scoped do
    subject(:root) { Scoped.new(store, []) }
    subject(:scoped) { Scoped.new(store, ["users", "72AC97F03A"]) }

    let(:store) { File.new("test.yml") }
    let(:other_store) { File.new("test_other.yml") }

    before do
      expect(root.get).to eq({})

      root.set("users", { "72AC97F03A" => {} })
    end

    it "behaves like a value object" do
      expect(root).to eq(Scoped.new(store, []))
      expect(scoped).to eq(Scoped.new(store, ["users", "72AC97F03A"]))

      expect(root).not_to eq(Scoped.new(store, ["hello"]))
      expect(root).not_to eq(Scoped.new(other_store, []))

      expect(root).not_to eq(nil)
      expect(root).not_to eq(Object)
      expect(root).not_to eq(Object.new)
    end

    describe "#scoped" do
      it "builds further scoped " do
        expect(root.scoped("items", "99A")).to eq(
          Scoped.new(store, ["items", "99A"])
        )

        expect(scoped.scoped("items", "99A")).to eq(
          Scoped.new(store, ["users", "72AC97F03A", "items", "99A"])
        )
      end
    end

    describe "#save" do
      it "persists the data" do
        scoped.set("items", { "123AA" => "sold" })

        scoped.save

        expect(
          Scoped.new(File.new("test.yml"), ["users", "72AC97F03A"]).get("items", "123AA")
        ).to eq("sold")
      end
    end

    describe "#get and #set" do
      it "gets the value given list of keys" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})
        scoped.set("hello", "world", "test", "12345")

        expect(scoped.get("hello", "world", "test")).to eq("12345")
        expect(root.get("users", "72AC97F03A", "hello", "world", "test")).to eq("12345")
      end
    end

    describe "#has?" do
      it "is true if key is present" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})
        scoped.set("hello", "world", "test", "12345")

        expect(scoped.has?("hello", "world", "test")).to eq(true)
        expect(root.has?("users", "72AC97F03A", "hello", "world", "test")).to eq(true)
      end

      it "is false if key is not present" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})

        expect(scoped.has?("hello", "world", "test")).to eq(false)
        expect(root.has?("users", "72AC97F03A", "hello", "world", "test")).to eq(false)
      end
    end

    describe "#get_or_set" do
      it "is current value if it is present" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})
        scoped.set("hello", "world", "test", "09876")

        expect(scoped.get_or_set("hello", "world", "test", "12345")).to eq("09876")
        expect(root.get_or_set("users", "72AC97F03A", "hello", "world", "test", "12345")).to eq("09876")
      end

      it "is default value if it is not present" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})

        expect(scoped.get_or_set("hello", "world", "test", "12345")).to eq("12345")
        expect(root.get_or_set("users", "72AC97F03A", "hello", "world", "test", "12345")).to eq("12345")
      end

      it "makes the value present if it wasn't" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})
        scoped.get_or_set("hello", "world", "test", "12345")

        expect(scoped.get("hello", "world", "test")).to eq("12345")
        expect(root.get("users", "72AC97F03A", "hello", "world", "test")).to eq("12345")
      end
    end

    describe "#fetch" do
      it "behaves like get if value is present" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})
        scoped.set("hello", "world", "test", "09876")

        expect(scoped.fetch("hello", "world", "test") { fail }).to eq("09876")
        expect(root.fetch("users", "72AC97F03A", "hello", "world", "test") { fail }).to eq("09876")
      end

      it "calls block if value is not present" do
        scoped.set("hello", {})
        scoped.set("hello", "world", {})

        expect {
          scoped.fetch("hello", "world", "test") { fail }
        }.to raise_error(RuntimeError)

        expect {
          root.fetch("users", "72AC97F03A", "hello", "world", "test") { fail }
        }.to raise_error(RuntimeError)
      end
    end
  end
end
