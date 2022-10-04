class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    def create
        lease = Lease.create!(lease_params)
        render json: lease, status: :created
    end

    def destroy
        lease = find_lease
        lease.destroy
        render json: {}, status: :no_content
    end

    private
    def lease_params
        params.permit(:apartment_id, :tenant_id, :rent)
    end
    def find_lease
        Lease.find_by!(id: params[:id])
    end

    def render_not_found_response
        render json: {error: "Lease not found"}, status: :not_found
    end

    def unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
