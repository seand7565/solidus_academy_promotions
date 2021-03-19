module MyApp
  module PromotionHandler
    class Query
      attr_reader :order, :promotion_code

      def initialize(order, promotion_code)
        @order = order
        @promotion_code = promotion_code
      end

      def activate
        if promotion && promotion.eligible?(order)
          promotion.activate(
            order: order,
            promotion_code: promotion_code
          )
        end
      end

      private

      def promotion
        @promotion ||= promotion_code&.promotion
      end
    end
  end
end
