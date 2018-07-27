module Api::Public::V1
  class SchemesController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:index, :show]

    def index
      schemes = Scheme
      render_serializer scope: schemes
    end

    def show
      render_serializer scope: scheme
    end

    def create
      scheme = schemable.schemes.create!(params_attributes)
      render_serializer scope: scheme
    end

    def update
      scheme.update_attributes!(params_attributes)
      render_serializer scope: scheme
    end

    private

    def params_attributes
      params.require(:scheme).permit(:name, :discount_type, :discount_units, :min_amount, :min_amount_type, :status, :expiry_at)
    end

    def scheme
      @scheme ||= Scheme.find(params[:id])
    end

    def schemable
      @schemable ||= if params[:schemable_type].downcase == 'vendor'
                       Vendor.find(params[:schemable_id])
                     else
                       Supplier.find(params[:schemable_id])
                     end
    end

    def valid_create?
      param! :schemable_id, Integer, required: true
      param! :schemable_type, String, required: true, blank: false,
             transform: -> (schemable_type) { schemable_type.downcase }, in: ['vendor', 'supplier']

      param! :scheme, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :discount_type, String
        s.param! :discount_units, Integer
        s.param! :min_amount, Float
        s.param! :min_amount_type, String
        s.param! :status, String
        s.param! :expiry_at, Time
      end
    end

    def valid_update?
      param! :schemable_id, Integer, required: true
      param! :schemable_type, String, required: true, blank: false,
             transform: -> (schemable_type) { schemable_type.downcase }, in: ['vendor', 'supplier']

      param! :scheme, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :discount_type, String
        s.param! :discount_units, Integer
        s.param! :min_amount, Float
        s.param! :min_amount_type, String
        s.param! :status, String
        s.param! :expiry_at, Time
      end
    end
  end
end
