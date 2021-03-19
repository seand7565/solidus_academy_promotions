module MyApp
  module Spree
    module StoreControllerDecorator
      def self.prepended(base)
        base.class_eval do
          before_action :activate_referral_promotions
        end
      end

      private

      def activate_referral_promotions
        MyApp::PromotionHandler::Query.new(
          current_order,
          promotion_code,
        ).activate

        cookies[:promotion_code_id] ||= promotion_code&.id
      end

      def promotion_code
        ::Spree::PromotionCode.find_by(id: cookies[:promotion_code_id]) ||
          ::Spree::PromotionCode.find_by(
            value: request.query_parameters[:r]
          )
      end

      ::Spree::StoreController.prepend self
    end
  end
end
