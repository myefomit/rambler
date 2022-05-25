module Orderable
  extend ActiveSupport::Concern

  DIRECTIONS = ['asc', 'desc']

  included do
    def apply_order(scope, params)
      orderer = params[:order_by]
      direction = params[:order_direction] || 'asc'

      if orderer.in?(orderers) && direction.in?(DIRECTIONS)
        scope.order "#{orderer} #{direction}"
      else
        scope
      end
    end
  end
end
