module Store2
  class File < Struct.new(:filename)
    def initialize(*args)
      super
      @data = load
      self.class.register(self)
    end

    def build
      scoped
    end

    def scoped(*keys)
      Scoped.new(self, keys)
    end

    def get(keys)
      keys.inject(data) { |data, key| data.fetch(key) }
    end

    def set(keys, value)
      get(keys[0...-1])[keys[-1]] = value
    end

    def has?(keys)
      get(keys[0...-1]).has_key?(keys[-1])
    end

    def get_or_set(keys, value)
      set(keys, value) unless has?(keys)
      get(keys)
    end

    def fetch(keys, &block)
      return block.call unless has?(keys)
      get(keys)
    end

    def save
      ::File.write(filename, to_yaml)
    end

    def _reset
      create
    end

    protected

    attr_reader :data

    private

    def load
      return create unless ::File.exist?(filename)
      YAML.load_file(filename)
    end

    def create
      clear
      save
      data
    end

    def clear
      @data = {}
    end

    def to_yaml
      data.to_yaml
    end
  end

  class << File
    def register(instance)
      instances << instance
    end

    def _reset
      instances.each(&:_reset)
    end

    private

    def instances
      @_instances ||= []
    end
  end
end
