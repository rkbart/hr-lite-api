class Api::AttendancesController < ApplicationController
   before_action :authenticate_user!
    before_action :set_attendance, only: [ :show, :update, :destroy ]

    # GET /api/attendances
    def index
      attendances = current_user.attendances.order(date: :desc)
      attendances = attendances.where(date: params[:start_date]..params[:end_date]) if params[:start_date] && params[:end_date]
      render json: attendances
    end

    # GET /api/attendances/:id
    def show
      render json: @attendance
    end

    # POST /api/attendances
    def create
      attendance = current_user.attendances.new(attendance_params)
      if attendance.save
        render json: attendance, status: :created
      else
        render json: { errors: attendance.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/attendances/:id
    def update
      if @attendance.update(attendance_params)
        render json: @attendance
      else
        render json: { errors: @attendance.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/attendances/:id
    def destroy
      @attendance.destroy
      head :no_content
    end

    # POST /api/attendances/clock_in
    def clock_in
      today = Date.current
      existing = current_user.attendances.find_by(date: today)
      if existing
        render json: { message: "Already clocked in today." }, status: :conflict
      else
        attendance = current_user.attendances.create(date: today, clock_in: Time.current)
        render json: attendance, status: :created
      end
    end

    # POST /api/attendances/clock_out
    def clock_out
      today = Date.current
      attendance = current_user.attendances.find_by(date: today)
      if attendance&.clock_out.nil?
        attendance.update(clock_out: Time.current)
        attendance.send(:calculate_total_hours) # recalculate total
        attendance.save
        render json: attendance
      else
        render json: { message: "Already clocked out or not clocked in yet." }, status: :unprocessable_entity
      end
    end

    # GET /api/attendances/summary?date=YYYY-MM-DD
    def summary
      date = params[:date] ? Date.parse(params[:date]) : Date.current
      attendance = current_user.attendances.find_by(date: date)
      if attendance
        render json: attendance
      else
        render json: { message: "No attendance record found for #{date}" }, status: :not_found
      end
    end

    private

    def set_attendance
      @attendance = current_user.attendances.find(params[:id])
    end

    def attendance_params
      params.require(:attendance).permit(:date, :clock_in, :clock_out, :total_hours)
    end
end
