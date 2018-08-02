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
      params.permit(:name, :status, metadata: {}, types: [])
    end

    #
    # @return [Supplier]
    #
    def supplier
      @supplier ||= Supplier.find(params[:id])
    end

    #
    # @return [String] Name search query
    #
    def search_query
      params[:name]&.strip
    end

    ######################
    #### VALIDATIONS ####
    ######################

    #
    # Validate create action params
    #
    def valid_create?
      param! :name, String, required: true, blank: false
      param! :status, String, in: ['active', 'inactive'], default: 'active'
      param! :metadata, Hash
      param! :types, Array
    end

    #
    # Validate update action params
    #
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
