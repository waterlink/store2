module Store2
  module Facade
    def open(filename)
      File.new(filename)
    end

    def _with_reset
      _reset
      yield
      _reset
    end

    def _reset
      File._reset
    end
  end
end
