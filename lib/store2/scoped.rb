module Store2
  class Scoped < Struct.new(:store, :scope)
    def scoped(*keys)
      Scoped.new(store, scope + keys)
    end

    def get(*keys)
      store.get(scope + keys)
    end

    def set(*keys, value)
      store.set(scope + keys, value)
    end

    def has?(*keys)
      store.has?(scope + keys)
    end

    def get_or_set(*keys, value)
      store.get_or_set(scope + keys, value)
    end

    def fetch(*keys, &block)
      store.fetch(scope + keys, &block)
    end

    def save
      store.save
    end

    def _reset
      store._reset
    end
  end
end
