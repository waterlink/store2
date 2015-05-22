module Store2
  RSpec.describe File do
    subject(:store) { File.new("test.yml") }

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

    describe "#save" do
      it "persists data" do
        store.set(["my_secret"], {})
        store.set(["my_secret", "password"], "is very secret")

        store.save

        expect(
          File.new("test.yml").get(["my_secret", "password"])
        ).to eq("is very secret")
      end
    end

    describe "#get and #set" do
      it "gets the value given list of keys" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})
        store.set(["hello", "world", "test"], "12345")

        expect(store.get(["hello", "world", "test"])).to eq("12345")
      end
    end

    describe "#has?" do
      it "is true if key is present" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})
        store.set(["hello", "world", "test"], "12345")

        expect(store.has?(["hello", "world", "test"])).to eq(true)
      end

      it "is false if key is not present" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})

        expect(store.has?(["hello", "world", "test"])).to eq(false)
      end
    end

    describe "#get_or_set" do
      it "is current value if it is present" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})
        store.set(["hello", "world", "test"], "09876")

        expect(store.get_or_set(["hello", "world", "test"], "12345")).to eq("09876")
      end

      it "is default value if it is not present" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})

        expect(store.get_or_set(["hello", "world", "test"], "12345")).to eq("12345")
      end

      it "makes the value present if it wasn't" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})
        store.get_or_set(["hello", "world", "test"], "12345")

        expect(store.get(["hello", "world", "test"])).to eq("12345")
      end
    end

    describe "#fetch" do
      it "behaves like get if value is present" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})
        store.set(["hello", "world", "test"], "09876")

        expect(store.fetch(["hello", "world", "test"]) { fail }).to eq("09876")
      end

      it "calls block if value is not present" do
        store.set(["hello"], {})
        store.set(["hello", "world"], {})

        expect { store.fetch(["hello", "world", "test"]) { fail } }
          .to raise_error(RuntimeError)
      end
    end
  end
end
