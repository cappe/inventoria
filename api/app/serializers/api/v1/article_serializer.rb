class Api::V1::ArticleSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :pid,
             :gtin,
             :unit

  attribute :saldo, if: -> { should_include?(:saldo) }
  attribute :saldo_total, if: -> { should_include?(:saldo_total) }
  attribute :products, if: -> { should_include?(:products) }
  attribute :is_commission_product, if: -> { should_include?(:is_commission_product) }

  def products
    options = {
      adapter: ActiveModelSerializers::Adapter::Attributes,
      each_serializer: Api::V1::ProductSerializer
    }

    ActiveModelSerializers::SerializableResource
      .new(products_not_used, options)
      .as_json
  end

  def saldo
    products_not_used.length
  end

  # Article have associated inventory_articles from
  # different inventories so we need to scope them here.
  def saldo_total
    ias = object
            .inventory_articles
            .select { |ia| ia.inventory_id == current_inventory.id }

    return 0 unless ias.length > 0

    ias.first.count
  end

  def is_commission_product
    saldo_total > 0
  end

  private

  # Article have associated products from different
  # inventories so we need to scope them here.
    def products_not_used
      @products_not_used ||= object
                             .products
                             .select { |p| p.inventory_id == current_inventory.id && !p.used? }
    end

    def current_inventory
      unless instance_options[:current_inventory].is_a?(Inventory)
        raise 'current_inventory is missing'
      end

      instance_options[:current_inventory]
    end
end
