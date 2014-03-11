class SamplesController < ApplicationController
  before_action :set_sample, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!

  def destroy
    authorize @sample

    @sample.destroy

    Reaction.find(params[:reaction_id]).update_attribute(:updated_at, DateTime.now)

    redirect_to reaction_url(Reaction.find(params[:reaction_id])), notice: 'Molecule was removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sample_params
      params.require(:sampl).permit(:target_amount, :actual_amount, :unit, :mol, :equivalent, :yield, :is_virtual, :is_startingmaterial, :molecule_attributes, :compound_id)
    end
end
