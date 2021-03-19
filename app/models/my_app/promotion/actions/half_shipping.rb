module MyApp
  module Promotion
    module Actions
      class HalfShipping < ::Spree::PromotionAction
        def perform(payload = {})
          order = payload[:order]
          promotion_code = payload[:promotion_code]

          results = order.shipments.map do |shipment|
            next false if shipment.adjustments.where(source: self).exists?

            shipment.adjustments.create!(
              order: shipment.order,
              amount: compute_amount(shipment),
              source: self,
              promotion_code: promotion_code,
              label: promotion.name,
            )

            true
          end

          results.any? { |result| result == true }
        end

        def compute_amount(shipment)
          shipment.cost * -0.5
        end

        def remove_from(order)
          order.shipments.each do |shipment|
            shipment.adjustments.each do |adjustment|
              if adjustment.source == self
                shipment.adjustments.destroy!(adjustment)
              end
            end
          end
        end
      end
    end
  end
end
