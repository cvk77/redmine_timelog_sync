class TimelogCalendarsController < ApplicationController
  unloadable
  
  def index
    cal = TimelogCalendar.by_user(User.current).first
    if cal != nil
        redirect_to :action => "edit", :id => cal.id
    else
        redirect_to :action => "new"
    end
  end

  def show
    redirect_to :action => "edit", :id => params[:id]
  end

  def new
    @calendar = TimelogCalendar.new
  end

  def edit
    @calendar = TimelogCalendar.find(params[:id])
  end
  
  def create
    @calendar = TimelogCalendar.new(params[:timelog_calendar])
    @calendar.user = User.current
    if @calendar.save
        flash[:notice] = 'Configuration saved'
        redirect_to @calendar
    else
        render :action => "new"
    end
  end
  
  def update
    @calendar = TimelogCalendar.find(params[:id])
    if @calendar.update_attributes(params[:timelog_calendar])
        flash[:notice] = 'Configuration updated'
        redirect_to @calendar
    else
        render :action => "edit"
    end
  end
  
end
