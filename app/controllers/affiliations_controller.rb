class AffiliationsController < ApplicationController

  before_filter :authenticate_user!, except: [:autocomplete_user_name, :autocomplete_country_name, :autocomplete_organization_name, :autocomplete_department_name, :autocomplete_group_name]

  def autocomplete_user_name

    result = User.where(["firstname ilike ? or lastname ilike ? or email ilike ?", params[:name]+"%", params[:name]+"%", params[:name]]).collect do |o|
      { value: o.firstname+" "+o.lastname,
        email: o.email
      }
    end
    render json: result
  end

  def autocomplete_country_name

    result = Country.where(["title ilike ?", "%"+params[:country]+"%"]).collect do |o|
      { value: o.title}
    end
    render json: result
  end

  def autocomplete_organization_name

    c = Country.find_by_title(params[:country])

    result = {}

    if !c.nil? then

      result = c.organizations.collect do |o|
        { value: o.title}
      end

    end
    render json: result
  end

  def autocomplete_department_name

    result = {}

    c = Country.find_by_title(params[:country])

    if !c.nil? then

      o = c.organizations.find_by_title(params[:organization])

      if !o.nil? then

        result = o.departments.collect do |o|
          { value: o.title}
        end

      end

    end
    render json: result
  end

  def autocomplete_group_name

    result = {}

    c = Country.find_by_title(params[:country])

    if !c.nil? then 
      o = c.organizations.find_by_title (params[:organization])

      if !o.nil? then 
        d = o.departments.find_by_title(params[:department])

        if !d.nil? then 
          result = d.groups.collect do |o|
            { value: o.title}
          end
        end
      end
    end
    render json: result
  end


end
