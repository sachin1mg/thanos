module Api::Public::V1
  class SuppliersController < ::Api::Public::AuthController
    skip_before_action :valid_action?, only: [:index, :show]

    def index
      suppliers = Supplier
      suppliers = suppliers.search(search_query) if search_query.present?
      render_serializer scope: suppliers
    end

    def show
      render_serializer scope: supplier
    end

    def create
      supplier = Supplier.create!(params_attributes)
      render_serializer scope: supplier
    end

    def update
      supplier.update_attributes!(params_attributes)
      render_serializer scope: supplier
    end

    private

    def params_attributes
      params.require(:supplier).permit(:name, :status, :metadata, types: [])
    end

    def supplier
      @supplier ||= Supplier.find(params[:id])
    end

    def search_query
      params[:name]&.strip
    end

    def valid_create?
      param! :supplier, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :status, String
        s.param! :metadata, Hash
        s.param! :types, Array
      end
    end

    def valid_update?
      param! :supplier, Hash, required: true, blank: false do |s|
        s.param! :name, String
        s.param! :status, String
        s.param! :metadata, Hash
        s.param! :types, Array
      end
    end
  end
end
