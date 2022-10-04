class TenantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    def index
        tenants = Tenant.all
        render json: tenants, status: :ok
    end

    def show
        tenant = find_tenant
        render json: tenant
    end

    def create
        tenant = Tenant.create!(tenant_params)
        render json: tenant, status: :created
    end

    def update
        tenant = find_tenant
        tenant.update
        render json: tenant, status: :ok
    end

    def destroy
        tenant = find_tenant
        tenant.destroy
        render json: {}, status: :no_content
    end

    private
    def find_tenant
        Tenant.find_by!(id: params[:id])
    end

    def tenant_params
        params.permit(:name, :age)
    end

    def unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def render_not_found_response
        render json: {error: "Tenant not found"}, status: :not_found
    end

end
