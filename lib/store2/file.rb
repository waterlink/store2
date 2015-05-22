module Store2
  class File < Struct.new(:filename)
    def build
      scoped
    end

    def scoped(*keys)
      Scoped.new(self, keys)
    end
  end
end
