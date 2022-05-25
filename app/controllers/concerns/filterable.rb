module Filterable
  extend ActiveSupport::Concern

  included do
    def apply_filters(initial_scope, params)
      filters.reduce(initial_scope) do |scope, filter|
        key, klass = filter
        if params[key].is_a?(klass)
          scope.send(key, params[key])
        else
          scope
        end
      end
    end
  end
end
