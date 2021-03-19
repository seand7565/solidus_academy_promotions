module MyApp
  module Promotion
    module Rules
      class NotInfluencer < ::Spree::PromotionRule
        preference :influencer_email, :string, default: ''

        validates :preferred_influencer_email, format: {
          allow_blank: true,
          with: /@/,
        }

        def applicable?(promotable)
          promotable.is_a?(::Spree::Order)
        end

        def eligible?(order, _options)
          order.email != preferred_influencer_email
        end
      end
    end
  end
end
